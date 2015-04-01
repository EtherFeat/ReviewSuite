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
			SetPermission(@"C:\Program Files\EtherFeat\ReviewClient\cache");
			SetPermission(@"C:\Program Files\EtherFeat\ReviewClient\cache\Downloads");
			SetPermission(@"C:\Program Files\EtherFeat\ReviewClient\cache\Extract");
	
			MessageBox.Show("Permissions was altered successfully!");
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
	}
}
