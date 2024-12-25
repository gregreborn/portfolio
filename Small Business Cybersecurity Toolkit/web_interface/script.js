document.getElementById("generate-plan").addEventListener("click", function () {
    const incidentType = document.getElementById("incident-type").value.trim();
    const affectedSystems = document.getElementById("affected-systems").value.trim();
    const mitigationSteps = document.getElementById("mitigation-steps").value.trim();

    // Validate inputs
    if (!validateIncidentType(incidentType)) {
        alert("Incident Type is required and must be at least 3 characters.");
        return;
    }

    if (!validateAffectedSystems(affectedSystems)) {
        alert("Affected Systems must be a comma-separated list.");
        return;
    }

    if (!validateMitigationSteps(mitigationSteps)) {
        alert("Mitigation Steps are required and must be at least one step.");
        return;
    }

    // Process input into a plan
    const systemsList = affectedSystems.split(",").map((system) => system.trim());
    const stepsList = mitigationSteps.split("\n").map((step) => step.trim());

    const plan = `
Incident Response Plan
----------------------
Incident Type: ${incidentType}

Affected Systems:
- ${systemsList.join("\n- ")}

Immediate Actions:
1. Isolate affected systems.
2. Notify team members.

Investigation Steps:
1. Run antivirus/malware scans.
2. Check logs for suspicious activity.

Mitigation:
${stepsList.map((step, index) => `${index + 1}. ${step}`).join("\n")}

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

// Validation Functions
function validateIncidentType(incidentType) {
    return incidentType.length >= 3; // At least 3 characters
}

function validateAffectedSystems(affectedSystems) {
    return affectedSystems.length > 0 && affectedSystems.includes(",");
}

function validateMitigationSteps(mitigationSteps) {
    return mitigationSteps.length > 0 && mitigationSteps.split("\n").length > 0;
}
