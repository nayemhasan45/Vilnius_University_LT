   M S B A M L   `   `   `  ����K  Gpassword_cracker, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null3clr-namespace:password_crackerpassword_cracker  5   	   !    password_cracker.MainWindow   5   	   W SPresentationCore, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5   	   R NSystem.Xaml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   0localclr-namespace:password_cracker     5   	     � Title$  
MainWindow��5   	   $	��450��6   $	��800��6)   
�������.��5
      � .+�5   
   �� $��10q�6   .+�5      �� $��Enter Password:��6   $	��200��6.   $��Center=�6:   �� 5      -   5         ��Name$ getPass��5      $	��200��6'   �� 5      -   5         ��Name$ 
encryptBtn��5      $��Encrypt Password��6)   $	��200��6D   $��0,10,0,0q�6P   
���E��
�������6�   �� 5      -   5        $ BruteForceBtn��5      $��Apply Brute Force��6,   $	��200��6H   $��0,10,0,0q�6T   
��� E��
�������6�   �� 5      $��Encrypted text:��6   $��0,10,0,0q�6.   $	��200��6@   $��Center=�6L   �� 5      -   5        $ encryptResult��5      $	��200��6-   �� 5      $��Decrypted password��6   $��0,10,0,0q�61   $	��200��6C   $��Center=�6O   �� 5      -   5        $ DecryptedPasswordTextBox��5      $	��200��68    �� 
IsReadOnly$
 True��6D   �� 5      -   5         ��Name$ ResultTextBlock��5      $��0,10,0,0q�61   5      5      5      