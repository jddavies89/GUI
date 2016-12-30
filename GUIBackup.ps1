<#
  .Description
    This is a little GUI script that is based on the Backup Media script i wrote, it does a full recursive backup.
 .Example
    .\GUIBackup.ps1
  .Notes
  Name  : GUIBackup.ps1
  Author: Joe Richards
  Date  : 30/12/2016
  .Link
  https://github.com/joer89/GUI/
#>

#Load the GUI Form.
function frmLoad {
    #Load System.Windows.Forms.
    [void][reflection.assembly]::loadwithpartialname("System.Windows.Forms") 
  
    #Set the form parameters.
    $frmMain = New-Object System.Windows.Forms.Form
    $frmMain.Text = "Backup Media"
    $frmMain.StartPosition = 1
    $frmMain.ClientSize = "490,240"

    #Set the label parameters.
    $lblCopyFrom = New-Object System.Windows.Forms.Label    
    $lblCopyFrom.Size = New-Object System.Drawing.Size(105,20) 
    $lblCopyFrom.Location = New-Object System.Drawing.Size(10,20) 
    $lblCopyFrom.Text = "Copy from :"
    $frmMain.Controls.Add($lblCopyFrom) 

    #Set the textbox parameters.
    $txtCopyFrom = New-Object System.Windows.Forms.TextBox    
    $txtCopyFrom.Size = New-Object System.Drawing.Size(200,20) 
    $txtCopyFrom.Location = New-Object System.Drawing.Size(120,20) 
    $frmMain.Controls.Add($txtCopyFrom) 

    #Set the label parameters.
    $lblPastFrom = New-Object System.Windows.Forms.Label    
    $lblPastFrom.Size = New-Object System.Drawing.Size(105,20) 
    $lblPastFrom.Location = New-Object System.Drawing.Size(10,50) 
    $lblPastFrom.Text = "Copy to :"
    $frmMain.Controls.Add($lblPastFrom) 

    #Set the textbox parameters.
    $txtPastTo = New-Object System.Windows.Forms.TextBox    
    $txtPastTo.Size = New-Object System.Drawing.Size(200,40) 
    $txtPastTo.Location = New-Object System.Drawing.Size(120,50) 
    $frmMain.Controls.Add($txtPastTo) 

    #Set the button parameters.
    $btnCopy = New-Object System.Windows.Forms.Button
    $btnCopy.Size = New-Object System.Drawing.Size(50,50) 
    $btnCopy.Location = New-Object System.Drawing.Size(10,100)    
    $btnCopy.Text = "Backup" 
    $btnCopy.Add_click($btnCopy_click)
    $frmMain.Controls.Add($btnCopy) 
      
    #Set the button parameters.
    $btnClose = New-Object System.Windows.Forms.Button
    $btnClose.Size = New-Object System.Drawing.Size(50,50) 
    $btnClose.Location = New-Object System.Drawing.Size(70,100)    
    $btnClose.Text = "Close" 
    $btnClose.Add_click($btnClose_click)
    $frmMain.Controls.Add($btnClose)
    
    #Set the label parameters.
    $lblProgress = New-Object System.Windows.Forms.Label
    $lblProgress.Size = New-Object System.Drawing.Size(450,20)
    $lblProgress.Location = New-Object System.Drawing.Size(130,130) 
    $lblProgress.Text = "Progress: User input."
    $frmMain.Controls.Add($lblProgress) 
    
    $progressBar = new-object Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Size(10,180)
    $progressBar.Size = New-Object System.Drawing.Size(470,40)
    #Implement the variables in the progress bar.
    #Hangs on 75% so i put the max of 75.
    $progressBar.Maximum = 75
    $progressBar.Minimum = 0
    $progressBar.Value = 0
    $progressBar.Name = 'progressBar'
    $progressBar.Style="Continuous"
    $frmMain.controls.add($progressBar)  

    #Set the preset variables.
    preSetVariables

    #Show the form.
    $frmMain.ShowDialog()
}

#On close button.
$btnClose_click = {
    #Close the form.
    $frmMain.Close()
}

#On invoke button.
$btnCopy_click = {

        #Start the backup process.
        backup
}

#Backup the data.
Function backup{

    try{
            #List the files in the array.
            $list = Get-ChildItem -Recurse -Path  $txtCopyFrom.Text
    
            #changes the label text on starting.
            $lblProgress.Text = "Progress: Started."
    
            #Backup TV series.
            for ($i =1; $i -lt $list.count; $i++){

                    #Calculate the percentage.
                    $Percentage = ($i/$list.Count)*100

                    #Creates a live progress bar of the TV files being copied.            
                    $progressBar.Value = $Percentage
           
                    #List the current TV episode being copied.
                    $lblProgress.Text = "Copying : $list[$i].FullName."

                    #Copy each file from TV directory to the backup directory. 
                    Copy-Item -Path $list[$i].FullName -Destination $txtPastTo.Text  -Recurse -Force

                    #Displays the current file being copied.
                    $lblProgress.Text = $list[$i].Name
                }
        }
        catch{
                $lblProgress.Text = "Error occured."
            }

   
    #Changes the label text when finished.
    $lblProgress.Text = "Progress: Finished."

}#End function.


#Populate the vaiables in the textbox.
function preSetVariables{

    #Define the veribles for copying my TV Programs.
    $txtCopyFrom.Text =  "T:\"
    $txtPastTo.Text = "G:\TV\"
}

#Loads the form.
frmLoad
