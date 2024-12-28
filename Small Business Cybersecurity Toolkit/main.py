from vulnerability_scanner.scanner import detect_common_vulnerabilities, run_scan
from vulnerability_scanner.validators import resolve_hostname, validate_ip, validate_hostname
from vulnerability_scanner.helpers import save_results
from vulnerability_scanner.firewall import block_ip, allow_ip


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


def firewall_menu():
    print("Firewall Simulation Menu:")
    print("1. Block an IP address")
    print("2. Allow an IP address")
    choice = input("Enter your choice (1 or 2): ")

    if choice not in ["1", "2"]:
        print("Invalid choice. Please enter 1 or 2.")
        return

    ip = input("Enter the IP address: ")
    if not validate_ip(ip):
        print("Invalid IP address. Please enter a valid IPv4 address (e.g., 192.168.1.1).")
        return

    protocol = input("Enter the protocol (tcp, udp, or any): ").strip().lower()
    if protocol not in ["tcp", "udp", "any"]:
        print("Invalid protocol. Please enter 'tcp', 'udp', or 'any'.")
        return

    if choice == "1":
        block_ip(ip, protocol)
    elif choice == "2":
        allow_ip(ip, protocol)



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
