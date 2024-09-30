namespace password_cracker.Models
{
    public static class passwordEncryptor
    {
        private static readonly string Salt = "STATIC_SALT";
        public static string Encrypt(string pass)
        {
            using(var sha256=System.Security.Cryptography.SHA256.Create())
            {
                var saltPass = pass + Salt;
                byte[]bytes=sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(saltPass));
                return System.Convert.ToBase64String(bytes);
            }
        }
    }
}
