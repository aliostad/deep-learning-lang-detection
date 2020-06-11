function save_options() {
  var showLabels = document.getElementById('show_labels').checked;
  var showCountries = document.getElementById('show_countries').checked;
  var showStates = document.getElementById('show_states').checked;
  var showProvinces = document.getElementById('show_provinces').checked;
  var showAustralianStates = document.getElementById('show_australian_states').checked;
  var showSupranationalUnions = document.getElementById('show_supranational_unions').checked;
  var showSovietRepublics = document.getElementById('show_soviet_republics').checked;
  chrome.storage.sync.set({
    showLabels: showLabels,
    showCountries: showCountries,
    showStates: showStates,
    showProvinces: showProvinces,
    showAustralianStates: showAustralianStates,
    showSupranationalUnions: showSupranationalUnions,
    showSovietRepublics: showSovietRepublics
  }, function() {
    var status = document.getElementById('status');
    status.textContent = 'Preferences saved!';
    setTimeout(function() {
      status.textContent = '';
    }, 750);
  });
}


function restore_options() {
  // Defaults
  chrome.storage.sync.get({
    showLabels: true,
    showCountries: true,
    showStates: false,
    showProvinces: false,
    showAustralianStates: false,
    showSupranationalUnions: false,
    showSovietRepublics: false
  }, function(data) {
    document.getElementById('show_labels').checked = data.showLabels;
    document.getElementById('show_countries').checked = data.showCountries;
    document.getElementById('show_states').checked = data.showStates;
    document.getElementById('show_provinces').checked = data.showProvinces;
    document.getElementById('show_australian_states').checked = data.showAustralianStates;
    document.getElementById('show_supranational_unions').checked = data.showSupranationalUnions;
    document.getElementById('show_soviet_republics').checked = data.showSovietRepublics;
  });
}
document.addEventListener('DOMContentLoaded', restore_options);
document.getElementById('save').addEventListener('click',
    save_options);