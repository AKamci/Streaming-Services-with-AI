using System.Net.Sockets;
using System.Net;
using System.Text;

namespace Security_Server
{
    public class Server
    {
        public static void Main()
        {
            // Sunucuyu başlat
            StartServer();
        }

        public static void StartServer()
        {
            // IP adresini ve port numarasını belirt
            IPAddress ipAddress = IPAddress.Parse("127.0.0.1"); // localhost
            int port = 8888;

            // IP adresi ve port numarası ile IPEndPoint oluştur
            IPEndPoint localEndPoint = new IPEndPoint(ipAddress, port);

            // TCP soketini oluştur
            Socket listener = new Socket(ipAddress.AddressFamily,
                SocketType.Stream, ProtocolType.Tcp);

            try
            {
                // Soketi bağla ve dinlemeye başla
                listener.Bind(localEndPoint);
                listener.Listen(10);

                Console.WriteLine("Sunucu başlatıldı...");

                while (true)
                {
                    Console.WriteLine("Bağlantı bekleniyor...");

                    // Gelen bağlantıları kabul et
                    Socket handler = listener.Accept();

                    // Gelen veriyi depolamak için bir tampon oluştur
                    byte[] buffer = new byte[1024];
                    int bytesRead = handler.Receive(buffer);

                    // Gelen veriyi ekrana yazdır
                    Console.WriteLine("İstemciden gelen veri: {0}",
                        Encoding.ASCII.GetString(buffer, 0, bytesRead));

                    // İstemciye yanıt gönder
                    string response = "Sunucudan gelen mesaj: Mesajınız alındı!";
                    byte[] responseBytes = Encoding.ASCII.GetBytes(response);
                    handler.Send(responseBytes);

                    // Soketi kapat
                    handler.Shutdown(SocketShutdown.Both);
                    handler.Close();
                }

            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            Console.WriteLine("\nSunucu kapatılıyor...");
        }



    }
}
