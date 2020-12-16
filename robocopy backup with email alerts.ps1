# PowerShell Robocopy script with e-mail notification. Andrew Palmer

# Change these values
$SourceFolder = "E:\DB_Backups"
$DestinationFolder = "\\server\Share"
$SourceFolder2 = "E:\Other_Source\Backups"
$DestinationFolder2 = "\\server\Share"
$Logfile = "C:\IT\Robocopy.log"
$EmailFrom = "alerts@<domain.com>"
$EmailTo = "IT@<domain.com>"
$EmailBody = "Robocopy task completed successfully. However, still see attached log file for details. FYI: For this job to continue to run in the future, configured user must keep session running, so keep that in mind when rebooting the server thanks."
$EmailSubject = "Robocopy done of backups onto target server"
$SMTPServer = "<SMTP server IP>"
$SMTPPort = "25"

# Copy Folder with Robocopy
Robocopy $SourceFolder $DestinationFolder /E /Z /R:1 /W:1 /PURGE /LOG:$Logfile
Robocopy $SourceFolder2 $DestinationFolder2 /E /Z /R:1 /W:1 /PURGE /LOG+:$Logfile

# Send E-mail message with log file attachment
$Message = New-Object Net.Mail.MailMessage($EmailFrom, $EmailTo, $EmailSubject, $EmailBody)
$Attachment = New-Object Net.Mail.Attachment($Logfile, 'text/plain')
$Message.Attachments.Add($Attachment)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, $SMTPPort)
$SMTPClient.Send($Message)
$Attachment.Dispose()