from vulnerability_scanner.scanner import detect_common_vulnerabilities, run_scan
from vulnerability_scanner.validators import resolve_hostname, validate_ip, validate_hostname, validate_ip_range
from vulnerability_scanner.helpers import save_results
from vulnerability_scanner.firewall import block_ip, allow_ip, expand_ip_range, test_connectivity
from colorama import Fore, Style, init

init(autoreset=True)  # Automatically reset colorama styles after each print

def get_input_with_back(prompt):
    """Helper function to get input and handle 'back' keyword."""
    while True:
        user_input = input(prompt).strip()
        if user_input.lower() == "back":
            return None  # Signal to go back
        return user_input

def vulnerability_scanner():
    print("Starting Vulnerability Scanner...")  # Debugging

    while True:
        target = get_input_with_back("Enter the IP address or hostname to scan (type 'back' to return): ")
        if target is None:  # Handle 'back'
            print("Returning to the main menu...")
            return

        print(f"User input target: {target}")  # Debugging

        if validate_hostname(target):
            resolved_ip = resolve_hostname(target)
            if resolved_ip is None:
                print("Failed to resolve hostname. Please check the hostname and try again.")
                continue
            target = resolved_ip

        if validate_ip(target):
            port_range = get_input_with_back("Enter the port range to scan (e.g., 1-1024) or type 'back': ") or "1-1024"
            if port_range is None:  # Handle 'back'
                continue
            if not valid_port_range(port_range):
                print("Invalid port range. Ensure it is in the format start-end (e.g., 1-1024).")
                continue
            results = run_scan(target, port_range)

            if "error" in results:
                print(results["error"])
                continue

            vulnerabilities = detect_common_vulnerabilities(results)
            if vulnerabilities:
                print("\nPotential vulnerabilities detected:")
                for warning in vulnerabilities:
                    print(f"- {warning}")
            print("Scan complete. Saving results...")
            save_results(results)
            print("Results saved to logs/scan_results.txt")
            break
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
    while True:
        print("Firewall Simulation Menu:(type 'back' to return at any prompt)")
        print("1. Block an IP address or range ")
        print("2. Allow an IP address or range")
        print("3. Batch Block IPs")
        print("4. Batch Allow IPs")
        print("5. Exit")
        choice = input("Enter your choice (1-5): ").strip()

        if choice == "5":  # Exit option
            print(f"{Fore.GREEN}{Style.BRIGHT}Exiting Firewall Simulation.")
            break

        if choice not in ["1", "2", "3", "4"]:
            print(f"{Fore.RED}{Style.BRIGHT}Invalid choice. Please enter a valid option.")
            continue

        if choice in ["1", "2"]:
            while True:
                ip_input = get_input_with_back("Enter the IP address, IP range (e.g., 192.168.1.0/24), or hostname: ")
                if ip_input is None:  # Handle 'back'
                    break
                try:
                    expand_ip_range(ip_input)  # Validate IP or range
                except ValueError as e:
                    print(f"{Fore.RED}{Style.BRIGHT}{str(e)}")
                    continue

                port = get_input_with_back("Enter the port (leave blank for all ports): ")
                if port is None:  # Handle 'back'
                    continue
                if port and not port.isdigit():
                    print(f"{Fore.RED}{Style.BRIGHT}Invalid port. Please enter a valid port number or leave blank for all ports.")
                    continue

                protocol = get_input_with_back("Enter the protocol (tcp, udp, or any): ")
                if protocol is None:  # Handle 'back'
                    continue
                if protocol not in ["tcp", "udp", "any"]:
                    print(f"{Fore.RED}{Style.BRIGHT}Invalid protocol. Please enter 'tcp', 'udp', or 'any'.")
                    continue

                if choice == "1":
                    block_ip(ip_input, protocol, port)
                elif choice == "2":
                    allow_ip(ip_input, protocol, port)
                break

        elif choice in ["3", "4"]:
            batch_action = "block" if choice == "3" else "allow"
            batch_process(batch_action)


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
