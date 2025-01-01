from vulnerability_scanner.scanner import detect_common_vulnerabilities, run_scan
from vulnerability_scanner.validators import resolve_hostname, validate_ip, validate_hostname, validate_ip_range
from vulnerability_scanner.helpers import save_results
from vulnerability_scanner.firewall import block_ip, allow_ip, expand_ip_range, test_connectivity


def vulnerability_scanner():
    print("Starting Vulnerability Scanner...")  # Debugging

    target = input("Enter the IP address or hostname to scan: ")
    print(f"User input target: {target}")  # Debugging

    # Resolve hostname if applicable
    if validate_hostname(target):
        print("Validating hostname...")  # Debugging
        resolved_ip = resolve_hostname(target)
        print(f"Resolved IP: {resolved_ip}")  # Debugging
        if resolved_ip is None:
            print("Failed to resolve hostname. Please check the hostname and try again.")
            return
        target = resolved_ip

    print(f"Target after validation: {target}")  # Debugging

    if validate_ip(target):
        print("Valid IP. Proceeding with scan...")  # Debugging
        port_range = input("Enter the port range to scan (e.g., 1-1024): ") or "1-1024"
        if not valid_port_range(port_range):
            print("Invalid port range. Ensure it is in the format start-end (e.g., 1-1024).")
            return
        print(f"Port range selected: {port_range}")  # Debugging
        results = run_scan(target, port_range)

        # Handle empty results gracefully
        if "error" in results:
            print(results["error"])
            return
        
        # Analyze for vulnerabilities
        vulnerabilities = detect_common_vulnerabilities(results)
        if vulnerabilities:
            print("\nPotential vulnerabilities detected:")
            for warning in vulnerabilities:
                print(f"- {warning}")

        print("Scan complete. Saving results...")
        save_results(results)
        print("Results saved to logs/scan_results.txt")
    else:
        print("Invalid IP address. Please ensure it is correctly formatted and try again.")


def batch_process(action):
    """Batch process IPs for blocking or allowing."""
    file_path = input("Enter the file path for the batch list (e.g., batch_ips.txt): ").strip()
    try:
        with open(file_path, "r") as file:
            total_lines = 0
            skipped_lines = 0
            processed_lines = 0

            for line in file:
                total_lines += 1
                line = line.strip()
                if not line:
                    print("Skipping empty or whitespace-only line.")
                    skipped_lines += 1
                    continue

                parts = line.split(",")
                if len(parts) != 2:
                    print(f"Invalid line format: {line}\nExpected format: 'IP,protocol'. Skipping.")
                    skipped_lines += 1
                    continue

                ip, protocol = parts[0].strip(), parts[1].strip().lower()

                # Validate IP
                if not validate_ip(ip):
                    print(f"Invalid IP address: {ip}. Skipping.")
                    skipped_lines += 1
                    continue

                # Validate protocol
                if protocol not in ["tcp", "udp", "any"]:
                    print(f"Invalid protocol: {protocol} for IP {ip}. Skipping.")
                    skipped_lines += 1
                    continue

                try:
                    # Perform the action (block or allow)
                    if action == "block":
                        block_ip(ip, protocol)
                    elif action == "allow":
                        allow_ip(ip, protocol)
                    processed_lines += 1
                except Exception as e:
                    print(f"Error processing IP {ip} with protocol {protocol}: {e}")
                    skipped_lines += 1
                    continue

            print(f"\nBatch processing completed:\n"
                  f"- Total lines: {total_lines}\n"
                  f"- Successfully processed: {processed_lines}\n"
                  f"- Skipped: {skipped_lines}")
    except FileNotFoundError:
        print(f"File not found: {file_path}. Please check the file path and try again.")
    except Exception as e:
        print(f"An error occurred during batch processing: {e}")



def firewall_menu():
    while True:  # Keep the menu running until the user explicitly exits
        print("Firewall Simulation Menu:")
        print("1. Block an IP address or range")
        print("2. Allow an IP address or range")
        print("3. Batch Block IPs")
        print("4. Batch Allow IPs")
        print("5. Exit")
        choice = input("Enter your choice (1-5): ").strip()

        if choice not in ["1", "2", "3", "4", "5"]:
            print("Invalid choice. Please enter a valid option.")
            continue  # Loop back to the menu

        if choice == "5":  # Exit option
            print("Exiting Firewall Simulation.")
            break

        if choice in ["1", "2"]:
            ip_input = input("Enter the IP address, IP range (e.g., 192.168.1.0/24), or hostname: ").strip()
            try:
                expand_ip_range(ip_input)  # Validate IP or range
            except ValueError as e:
                print(str(e))
                continue

            port = input("Enter the port (leave blank for all ports): ").strip()
            if port and not port.isdigit():
                print("Invalid port. Please enter a valid port number or leave blank for all ports.")
                continue

            protocol = input("Enter the protocol (tcp, udp, or any): ").strip().lower()
            if protocol not in ["tcp", "udp", "any"]:
                print("Invalid protocol. Please enter 'tcp', 'udp', or 'any'.")
                continue

            if choice == "1":
                block_ip(ip_input, protocol, port)
            elif choice == "2":
                allow_ip(ip_input, protocol, port)

        elif choice in ["3", "4"]:
            batch_action = "block" if choice == "3" else "allow"
            batch_process(batch_action)

    print("Firewall Simulation Menu:")
    print("1. Block an IP address or range")
    print("2. Allow an IP address or range")
    print("3. Batch Block IPs")
    print("4. Batch Allow IPs")
    choice = input("Enter your choice (1-4): ")

    if choice not in ["1", "2", "3", "4"]:
        print("Invalid choice. Please enter a valid option.")
        return

    if choice in ["1", "2"]:
        ip_input = input("Enter the IP address, IP range (e.g., 192.168.1.0/24), or hostname: ").strip()
        try:
            expand_ip_range(ip_input)  # Validate IP or range
        except ValueError as e:
            print(str(e))
            return

        port = input("Enter the port (leave blank for all ports): ").strip()
        if port and not port.isdigit():
            print("Invalid port. Please enter a valid port number or leave blank for all ports.")
            return

        protocol = input("Enter the protocol (tcp, udp, or any): ").strip().lower()
        if protocol not in ["tcp", "udp", "any"]:
            print("Invalid protocol. Please enter 'tcp', 'udp', or 'any'.")
            return

        if choice == "1":
            block_ip(ip_input, protocol, port)
        elif choice == "2":
            allow_ip(ip_input, protocol, port)
    print("Firewall Simulation Menu:")
    print("1. Block an IP address or range")
    print("2. Allow an IP address or range")
    print("3. Batch Block IPs")
    print("4. Batch Allow IPs")
    choice = input("Enter your choice (1-4): ")

    if choice not in ["1", "2", "3", "4"]:
        print("Invalid choice. Please enter a valid option.")
        return

    if choice in ["1", "2"]:
        ip_input = input("Enter the IP address, IP range (e.g., 192.168.1.0/24), or hostname: ")
        port = input("Enter the port (leave blank for all ports): ").strip() or "any"
        protocol = input("Enter the protocol (tcp, udp, or any): ").strip().lower()

        # Validate protocol
        if protocol not in ["tcp", "udp", "any"]:
            print("Invalid protocol. Please enter 'tcp', 'udp', or 'any'.")
            return

        # Check if input is an IP range
        if validate_ip_range(ip_input):
            print(f"Processing IP range: {ip_input}")
            ips = expand_ip_range(ip_input)  # Expand the range into individual IPs
        elif validate_ip(ip_input):
            ips = [ip_input]  # Single IP
        else:
            print(f"Invalid IP or range: {ip_input}. Exiting.")
            return

        # Optional connectivity test
        for ip in ips:
            if not test_connectivity(ip):
                print(f"IP {ip} is unreachable. Skipping.")

        # Perform the action
        for ip in ips:
            if choice == "1":
                block_ip(ip, protocol, port)
            elif choice == "2":
                allow_ip(ip, protocol, port)
    elif choice == "3":
        batch_process("block")
    elif choice == "4":
        batch_process("allow")


def valid_port_range(port_range):
    """Validate port range format and values."""
    try:
        start, end = map(int, port_range.split("-"))
        return 1 <= start <= 65535 and 1 <= end <= 65535 and start <= end
    except ValueError:
        return False


if __name__ == "__main__":
    print("Cybersecurity Toolkit")
    print("1. Vulnerability Scanner")
    print("2. Firewall Simulation")
    choice = input("Enter your choice (1 or 2): ")

    if choice == "1":
        vulnerability_scanner()
    elif choice == "2":
        firewall_menu()
    else:
        print("Invalid choice. Exiting.")
