
using System.Windows;
using password_cracker.Models;
using System;
using System.Diagnostics;


namespace password_cracker
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }
        private void encryptBtnClicked(object sender, RoutedEventArgs e)
        {
            string pass = getPass.Text;
            if(!string.IsNullOrEmpty(pass) )
            {
                string encryptedPass = passwordEncryptor.Encrypt(pass);
                encryptResult.Text = encryptedPass;
            }
            else
            {
                getPass.Text = "Please enter a password";
            }
        }
        private async void bruteForceClicked(object sender, RoutedEventArgs e)
        {
            string encryptedText = encryptResult.Text;
            if (string.IsNullOrEmpty(encryptedText))
            {
                MessageBox.Show("plese enter pass first");
            }
            string result = await BruteForceAttack.crackPassword(encryptedText);
            DecryptedPasswordTextBox.Text = result;
        }
    }
}