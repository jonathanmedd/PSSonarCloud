<#
  _____   _____ _____                         _____ _                 _
 |  __ \ / ____/ ____|                       / ____| |               | |
 | |__) | (___| (___   ___  _ __   __ _ _ __| |    | | ___  _   _  __| |
 |  ___/ \___ \\___ \ / _ \| '_ \ / _` | '__| |    | |/ _ \| | | |/ _` |
 | |     ____) |___) | (_) | | | | (_| | |  | |____| | (_) | |_| | (_| |
 |_|    |_____/_____/ \___/|_| |_|\__,_|_|   \_____|_|\___/ \__,_|\__,_|

#>

# --- Clean up psSonarCloudConnection variable on module remove
$ExecutionContext.SessionState.Module.OnRemove = {

    Remove-Variable -Name SonarCloudConnection -Force -ErrorAction SilentlyContinue

}