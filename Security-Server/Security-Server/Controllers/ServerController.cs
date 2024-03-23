using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace Security_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ServerController : ControllerBase
    {
        private readonly ServerService _serverService;
        private readonly JWT_Settings _jwtAyarlari;

        public ServerController(ServerService serverService, IOptions<JWT_Settings> jwtAyarlari)
        {
            _serverService = serverService;
            _jwtAyarlari = jwtAyarlari.Value;
        }

        [HttpPost]
        public async Task<IActionResult> Update_Email(UpdateMail updateMail)
        {
            var returned = await _serverService.Update_Email(updateMail);

            return Ok(returned);
        }





    }
}
