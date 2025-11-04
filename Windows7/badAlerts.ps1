Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

function Show-CustomPopUpAlert {
    param (
        [string]$Title = "Alert",
        [string]$Message = "This is a bad alert",
        [string]$ButtonText = "COOKED"
    )

    Add-Type -AssemblyName System.Windows.Forms

    #form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.BackColor = "Black"
    $form.ForeColor = "White"

    #label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Message
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.ForeColor = "White"
    $form.Controls.Add($label)

    #button
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $ButtonText
    $button.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $button.Location = New-Object System.Drawing.Point(160, 100)
    $button.Size = New-Object System.Drawing.Size(80, 30)
    $button.BackColor = "Red"
    $button.ForeColor = "White"
    $form.Controls.Add($button)

    #border color to red
    $form.BorderStyle = "FixedSingle"
    $form.Add_Shown({$form.Refresh()})
    $form.Add_Paint({
        $g = $_.Graphics
        $g.DrawRectangle([System.Drawing.Pens]::Red, 0, 0, $form.ClientSize.Width - 1, $form.ClientSize.Height - 1)
    })

    #the form
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null
}

function Log-Event {
    param (
        [string]$Message
    )
    $logPath = "C:\path\to\your\logfile.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    Add-Content -Path $logPath -Value $logEntry
}

# file has been modified
$filePath = "C:\path\to\your\file.txt"
$lastModified = (Get-Item $filePath).LastWriteTime

if ($lastModified -gt (Get-Date).AddMinutes(-10)) {
    $alertMessage = "The file $filePath has been modified in the last 10 minutes."
    Show-CustomPopUpAlert -Title "File Modification Alert" -Message $alertMessage -ButtonText "OK"
    Log-Event -Message $alertMessage
}
