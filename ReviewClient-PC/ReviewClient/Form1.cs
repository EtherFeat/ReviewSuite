using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Net;
using System.Security.AccessControl;
using Ionic.Zip;



namespace ReviewClient
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            
            InitializeComponent();
            CheckStructure();
            CheckDate();
            progressBar1.Visible = false;
        }




        private string[] files;
        private string[] filesForOpen;
        private string pathtofile, filename, fileForOpen, pathToFileForOpen,pathToExtractedFile;
        private string pathToExtract = Application.StartupPath + @"\cache\Extract\";
        private string pathToDownloads = Application.StartupPath + @"\cache\Downloads\";
        private string[] search;
        string[] extractedfolders;







        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            LocalStart();
        }
        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            RemoteStart();
        }
        void LocalStart()
        {
            files = GetListOfFiles();
            additems(files);
            search = files;
        }
        void RemoteStart()
        {
            extractedfolders = Directory.GetDirectories(pathToExtract);
            additems(extractedfolders);
            search = extractedfolders;
        }      
        private void button1_Click(object sender, EventArgs e)
        {
            if (radioButton1.Checked)
                LocalStart();
            if (radioButton2.Checked)
                RemoteStart();
        }
        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string item = GetSelected();
                byte type;
                if (radioButton1.Checked)
                {
                    if (item.Contains("Connection problem"))
                        type = 2;
                    else if (item.Length == 0)
                        type = 3;
                    else if (item.Contains(".zip") || item.Contains(".ZIP") == true)
                        type = 0;

                    else type = 1;
                    switch (type)
                    {
                        case 0: Extract(); break;
                        case 1: View(); break;
                        case 2: MessageBox.Show("Connection problem, please check your connection!"+ 
                            "\n If server is temporarily unavailable, use your local storage!", 
                            "Connection problem", MessageBoxButtons.OK, MessageBoxIcon.Warning,
                            MessageBoxDefaultButton.Button1,MessageBoxOptions.DefaultDesktopOnly); break;
                        case 3: break;
                    }
                }
                if (radioButton2.Checked)
                {
                    if (item.Contains(".zip") || item.Contains(".ZIP"))
                        type = 0;
                    else type = 1;
                    switch (type)
                    {
                        case 0: BrowseExtractedFolder(); break;
                        case 1: View(); break;
                    }
                }
            }
            catch (NullReferenceException){}
        }
        public static string DetectPath(string[] paths, string filename)
        {
             string path = null;
             try
             {
                 if (paths != null)
                 {
                     for (int n = 0; n < paths.Length; n++)
                     {
                         if (paths[n].Contains(filename) == true)
                         { path = paths[n]; }
                     }
                 }
             }
             catch (NullReferenceException) { }
             return path;
            
        }
        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            string pattern = textBox1.Text;
            listBox1.Items.Clear();
            if (search != null)
            {
                for (int s = 0; s < search.Length; s++)
                {
                if (search[s].Contains(pattern))
                    listBox1.Items.Add(Path.GetFileName(search[s]));
                }
            }
            
        }
        private void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            progressBar1.Value = e.ProgressPercentage;
        }
        public string GetSelected()
        {
            string nameofselecteditem = null;
            for (int k = 0; k < listBox1.Items.Count; k++)
                {
                    if (listBox1.GetSelected(k) == true)
                        nameofselecteditem = listBox1.Items[k].ToString();
                }
            return nameofselecteditem; 
                       
        }
        void additems(string[] items)
        {
            listBox1.Items.Clear();
            try
            {
                for (int i = 0; i < items.Length; i++)
                {
                    listBox1.Items.Add(Path.GetFileName(items[i]));
                }
            }
            catch (NullReferenceException) { }
        }
        void Extract()
        {
            try
            {
                progressBar1.Visible = true;
                filename = GetSelected();
                pathtofile = DownloadZip(filename);
                progressBar1.Value = 10;
                using (ZipFile zip = ZipFile.Read(pathtofile))
                {
                    pathToExtractedFile = pathToExtract + filename;
                    if (Directory.Exists(pathToExtractedFile))
                        Directory.Delete(pathToExtractedFile, true);
                    foreach (ZipEntry zif in zip.Entries)
                    {
                        progressBar1.Value = 30;
                        zif.Extract(pathToExtractedFile);
                        progressBar1.Value = 90;
                    }
                }
                filesForOpen = Directory.GetFiles(pathToExtractedFile);
                additems(filesForOpen);
                progressBar1.Value = 100;
                search = filesForOpen;
                progressBar1.Value = 0;
                progressBar1.Visible = false;
            }
            catch (UnauthorizedAccessException)
            {
                MessageBox.Show("Access is denied!", "Warning", MessageBoxButtons.OK,
                    MessageBoxIcon.Error, MessageBoxDefaultButton.Button1);
            }
            catch (FileNotFoundException)
            {
                MessageBox.Show("File is not found!", "Warning", MessageBoxButtons.OK,
                    MessageBoxIcon.Error, MessageBoxDefaultButton.Button1);
            }
            catch (NullReferenceException) { }
        }
        void View()
        {
            fileForOpen = GetSelected();
           
                pathToFileForOpen = DetectPath(filesForOpen, fileForOpen);
                webBrowser1.Navigate(pathToFileForOpen);
            
        }
        public string[] GetListOfFiles()
        {
            progressBar1.Visible = true;
            progressBar1.Value = 30;
            string[] error = new string[] {"Connection problem"};
            Uri url =new Uri(@"http://www.etherfeat.com/review/source/current");
            string result = null;
            WebResponse response = null;
            StreamReader reader = null;
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.Method = "GET";
                
                response = request.GetResponse();
                reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8);
                result = reader.ReadToEnd();
                progressBar1.Value = 80;
                string[] lines = result.Split('\n');
                progressBar1.Value = 100;
                progressBar1.Value = 0;
                progressBar1.Visible = false;
                return lines;
            }
            catch (WebException)
            {
                progressBar1.Value = 0;
                progressBar1.Visible = false; 
                return error;
            }
           
        }
        public string DownloadZip(string zipfilename)
        {
            progressBar1.Visible = true;
            string pathtodownloadedfile = pathToDownloads + zipfilename;
            if (File.Exists(pathtodownloadedfile))
                File.Delete(pathtodownloadedfile);
            string link = @"http://www.etherfeat.com/review/source/" + zipfilename;
            if (File.Exists(pathtodownloadedfile) == true)
                File.Delete(pathtodownloadedfile);
            Uri url = new Uri(link);
            System.Net.HttpWebRequest request = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(url);
            System.Net.HttpWebResponse response = (System.Net.HttpWebResponse)request.GetResponse();
            response.Close();
            long iSize = response.ContentLength;
            long iRunningByteTotal = 0;
            WebClient webClient = new WebClient();
            Stream streamRemote = webClient.OpenRead(new Uri(link));
            Stream streamLocal = new FileStream(pathtodownloadedfile, FileMode.Create, FileAccess.Write, FileShare.None);
            int iByteSize = 0;
            byte[] byteBuffer = new byte[iSize];
            while ((iByteSize = streamRemote.Read(byteBuffer, 0, byteBuffer.Length)) > 0)
            {
            streamLocal.Write(byteBuffer, 0, iByteSize);
            iRunningByteTotal += iByteSize;
            double dIndex = (double)(iRunningByteTotal);
            double dTotal = (double)byteBuffer.Length;
            double dProgressPercentage = (dIndex / dTotal);
            int iProgressPercentage = (int)(dProgressPercentage * 100);
            backgroundWorker1.ReportProgress(iProgressPercentage);
            }
            streamLocal.Close();
            streamRemote.Close();
            progressBar1.Value = 0;
            progressBar1.Visible = false;
            return pathtodownloadedfile;
        }
        private void BrowseExtractedFolder()
        {
            string foldername = GetSelected();
            try
            {
                filesForOpen = Directory.GetFiles(DetectPath(extractedfolders, foldername));
                additems(filesForOpen);
                search = filesForOpen;
            }
            catch (DirectoryNotFoundException) {}
            
        }
        private void CheckStructure()
        {
                try
                {
                    if (Directory.Exists(pathToDownloads) == false)
                    {
                    Directory.CreateDirectory(pathToDownloads);
                    }
                    if (Directory.Exists(pathToExtract) == false)
                    {
                        Directory.CreateDirectory(pathToExtract);
                    }

                    AuthorizationRuleCollection rules;
                    rules = Directory.GetAccessControl(pathToDownloads)
                                    .GetAccessRules(true, true, typeof(System.Security.Principal.NTAccount));
                    rules = Directory.GetAccessControl(pathToExtract)
                                    .GetAccessRules(true, true, typeof(System.Security.Principal.NTAccount));

                    

                }
            
                catch (UnauthorizedAccessException)
                {
                    MessageBox.Show("Access is denied!", "Warning", MessageBoxButtons.OK,
                        MessageBoxIcon.Error, MessageBoxDefaultButton.Button1);
                }
        }
        private void CheckDate()
        {
            string[] files = Directory.GetFiles(pathToDownloads);
            foreach (string file in files)
            {
                if (File.GetLastWriteTime(file).ToShortDateString() != DateTime.Now.ToShortDateString())
                {
                    File.Delete(file);
                    Directory.Delete(pathToExtract + Path.GetFileName(file),true);
                }
            }
        }
        

    }
}
