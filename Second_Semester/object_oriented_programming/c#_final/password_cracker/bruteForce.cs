using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace password_cracker.Models
{
    public class BruteForceAttack
    {
        private const string Chars = "abcdefghijklmnopqrstuvwxyz";
        private const int maxThereads = 3;
        public static async Task<string>crackPassword(string encryptedText)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            string result = null;
            await Task.Run(() =>
            {
                ParallelOptions parallelOptions = new ParallelOptions { MaxDegreeOfParallelism = maxThereads };
                Parallel.ForEach(getAllPass(), parallelOptions, (password, state) =>
                {
                    if (passwordEncryptor.Encrypt(password) == encryptedText)
                    {
                        result = password;
                        state.Stop();
                    }
                });

            });
            stopwatch.Stop();
            return (result);
        }
        private static IEnumerable<string> getAllPass()
        {
            var que=new Queue<string>();
            que.Enqueue("");
            while(que.Count > 0)
            {
                string current = que.Dequeue();
                foreach(char ch in Chars)
                {
                    string next = current + ch;
                    yield return next;
                    que.Enqueue(next);
                }
            }
        }
        
    }
}
