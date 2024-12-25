document.getElementById("generate-plan").addEventListener("click", function () {
    const incidentType = document.getElementById("incident-type").value;
    const affectedSystems = document.getElementById("affected-systems").value.split(",");
    const mitigationSteps = document.getElementById("mitigation-steps").value.split("\n");

    if (!incidentType || !affectedSystems || !mitigationSteps) {
        alert("Please fill in all fields!");
        return;
    }

    const plan = `
Incident Response Plan
----------------------
Incident Type: ${incidentType}

Affected Systems:
- ${affectedSystems.join("\n- ")}

Immediate Actions:
1. Isolate affected systems.
2. Notify team members.

Investigation Steps:
1. Run antivirus/malware scans.
2. Check logs for suspicious activity.

Mitigation:
${mitigationSteps.map((step, index) => `${index + 1}. ${step}`).join("\n")}

Recovery:
1. Restore from backups.
2. Update all passwords.

Lessons Learned:
- Document the incident.
- Review what went wrong.
- Improve processes.
`;

    document.getElementById("generated-plan").textContent = plan;
    document.getElementById("output").style.display = "block";
});

document.getElementById("download-plan").addEventListener("click", function () {
    const planText = document.getElementById("generated-plan").textContent;
    const blob = new Blob([planText], { type: "text/plain" });
    const url = URL.createObjectURL(blob);

    const a = document.createElement("a");
    a.href = url;
    a.download = "incident_response_plan.txt";
    a.click();

    URL.revokeObjectURL(url);
});
