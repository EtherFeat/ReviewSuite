using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using System.IO;
using System.Management;
using System.Management.Instrumentation;
using System.Security.AccessControl;

namespace permission
{
	
	public partial class MainForm : Form
	{
		public MainForm()
		{
			InitializeComponent();
			GetUsers();
		}
		
		void Button1Click(object sender, EventArgs e)
		{
            string path = ChoosedDirectory();
            if (File.Exists(path + @"\ReviewClient.exe") && path != null)
            {
                SetPermission(path + @"\cache");
                SetPermission(path + @"\cache\Downloads");
                SetPermission(path + @"\cache\Extract");

                MessageBox.Show("Permissions was altered successfully!");
            }
            else { MessageBox.Show("Please, choose correct directory or choose user", "Warning!", MessageBoxButtons.OK, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1, MessageBoxOptions.DefaultDesktopOnly); }
		}
		
		private void SetPermission(string path)
		{
			string User = System.Environment.UserDomainName + "\\" + comboBox1.SelectedItem.ToString();
			DirectoryInfo dinfoDownloads = new DirectoryInfo(path);
			DirectorySecurity dsecurityDownloads = dinfoDownloads.GetAccessControl();
			dsecurityDownloads.AddAccessRule(new FileSystemAccessRule(User,FileSystemRights.FullControl ,AccessControlType.Allow));
			dinfoDownloads.SetAccessControl(dsecurityDownloads);
		}
		
		private void GetUsers()
		{
			SelectQuery Query = new SelectQuery("Win32_UserAccount", "Domain='" + System.Environment.UserDomainName.ToString() + "'");
			try
				{
					ManagementObjectSearcher Searcher = new ManagementObjectSearcher(Query);
					foreach (ManagementObject mObject in Searcher.Get())
					{
						comboBox1.Items.Add(mObject["Name"]);
					}
				}
			catch(Exception e) {MessageBox.Show(e.ToString());}
		}
        private string ChoosedDirectory()
        {
            string path = null;
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                path = folderBrowserDialog1.SelectedPath;
            }
            return path;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            MessageBox.Show("1. Choose user \n2. Push button \"Set permmision\"\n3. Choose directore where was installed ReviewClient" + 
                 "\n(Deffault folder is \"Programm files\\EtherFeat\\ReviewClient\")\n4. Reboot the computer");
        }
	}
}
