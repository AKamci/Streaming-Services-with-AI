namespace Main_Server.Models
{
    public class User
    {
        public string Id { get; set; }

        public string Email { get; set; }

        public List<SubUser> SubUser { get; set; }

    }
}
