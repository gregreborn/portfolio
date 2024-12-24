from vulnerability_scanner.scanner import run_scan
from vulnerability_scanner.validators import resolve_hostname, validate_ip, validate_hostname
from vulnerability_scanner.helpers import save_results

def main():
    print("Starting Cybersecurity Toolkit...")  # Debugging

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

if __name__ == "__main__":
    main()
