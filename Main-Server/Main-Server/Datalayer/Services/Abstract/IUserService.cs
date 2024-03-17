using Main_Server.Infrastructure;
using Main_Server.Models;

namespace Main_Server.Datalayer.Services.Abstract
{
    public interface IUserService:IServiceBase<User>
    {
        Result<User> DecodeToken(User entity);

    }
}
