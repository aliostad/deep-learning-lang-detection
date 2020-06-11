//Show more Patients
$('#morepatients').click(function () {
    $('#patientlist2').show();
    $('#patientlist').hide();
});

//Go back
$('#patientsback').click(function () {
    $('#patientlist').show();
    $('#patientlist2').hide();
});

//Show more Complaints
$('#morecomplaints').click(function () {
    $('#complaints2').show();
    $('#complaints').hide();
});

//Go back
$('#complaintsback').click(function () {
    $('#complaints').show();
    $('#complaints2').hide();
});

//Show more Alerts
$('#morealerts').click(function () {
    $('#alerts2').show();
    $('#alerts').hide();
});

//Go back
$('#alertsback').click(function () {
    $('#alerts').show();
    $('#alerts2').hide();
});