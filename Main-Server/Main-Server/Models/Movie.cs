namespace Main_Server.Models
{
    public class Movie
    {
        public string MovieId  { get; set; }

        public string MovieName { get; set; }

        public string MoviePoster { get; set; }

        public string MovieDescription { get; set; }

        public DateTime ReleaseYear { get; set; }

        public string Director { get; set; }

        public string Cast { get; set; }

        public string Category { get; set; }

        public decimal Views { get; set; }

       
    }
}
