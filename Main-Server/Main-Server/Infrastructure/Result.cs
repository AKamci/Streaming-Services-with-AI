
namespace Main_Server.Infrastructure
{
    public class Result<T>
    {
        private readonly RequestDelegate _next;
        private readonly ILogger _logger;

        private Result(T value, bool isSuccess, string message)
        {
            Value = value;
            IsSuccess = isSuccess;
            Message = message;
        }

        public Result(RequestDelegate next, ILogger<Result<T>> logger)
        {
            _next = next;
            _logger = logger;
        }

        public T Value { get; }

        public string Message { get; set; }

        public bool IsSuccess { get; }

        public bool IsFailure => !IsSuccess;

        public static Result<T> Success(T value, string message) => new(value, true, message);

        public static Result<T> Failure(string message) => new(default, false, message);

        public async Task ExecuteAsync(HttpContext httpContext)
        {
            try
            {
                _logger.LogInformation("İstek alındı: {Path}", httpContext.Request.Path);

                // Önceki middleware bileşenlerine (pipeline'daki) ilerleme
                await _next(httpContext);

                _logger.LogInformation("İstek işlendi. Durum kodu: {StatusCode}", httpContext.Response.StatusCode);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "İstek işlenirken bir hata oluştu.");

                // Hata durumunda istemciye uygun bir hata yanıtı gönderme işlemi yapılabilir.
                httpContext.Response.StatusCode = 500;
                await httpContext.Response.WriteAsync("Internal Server Error");
            }
        }


    }
}
