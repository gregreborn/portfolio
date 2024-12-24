from vulnerability_scanner.scanner import run_scan
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
            print("Failed to resolve hostname. Exiting.")
            return
        target = resolved_ip

    print(f"Target after validation: {target}")  # Debugging

    if validate_ip(target):
        print("Valid IP. Proceeding with scan...")  # Debugging
        port_range = input("Enter the port range to scan (e.g., 1-1024): ") or "1-1024"
        print(f"Port range selected: {port_range}")  # Debugging
        results = run_scan(target, port_range)

        # Handle empty results gracefully
        if "error" in results:
            print(results["error"])
            return

        print("Scan complete. Saving results...")
        save_results(results)
        print("Results saved to logs/scan_results.txt")
    else:
        print("Invalid IP address or hostname. Please try again.")


def firewall_menu():
    print("Firewall Simulation Menu:")
    print("1. Block an IP address")
    print("2. Allow an IP address")
    choice = input("Enter your choice (1 or 2): ")

    ip = input("Enter the IP address: ")
    if not validate_ip(ip):
        print("Invalid IP address. Exiting.")
        return

    if choice == "1":
        block_ip(ip)
    elif choice == "2":
        allow_ip(ip)
    else:
        print("Invalid choice. Exiting.")


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
