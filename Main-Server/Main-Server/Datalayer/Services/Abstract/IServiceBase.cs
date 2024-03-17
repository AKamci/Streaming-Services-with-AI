using Main_Server.Infrastructure;

namespace Main_Server.Datalayer.Services.Abstract
{
    public interface IServiceBase<T>
    {
        Task<Result<T>> GetById(string id);
        Task<Result<T>> GetAll();
        Task<Result<T>> Create(T entity);

        Task<Result<T>> Add(T entity);
        Task<Result<T>> Update(T entity);
        Task<Result<bool>> Delete(T entity);
    }
}
