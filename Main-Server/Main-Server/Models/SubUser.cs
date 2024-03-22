using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using System.Runtime.CompilerServices;

namespace Main_Server.Models
{
    public class SubUser
    {
        public string UserId { get; set; }
  
        public string SubId { get; set; }

        public string Name { get; set; }

        public string Surname { get; set; }

        public string Image { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public int PIN { get; set; }

        public List<Movie> Movies { get; set; }

        public List<Movie> FavoriteFilms { get; set; }

        public Movie LastWatched { get; set; }

        public List<Movie> FinishedMovies { get; set; }

        public List<Censor> Censors { get; set; }

    }
}
