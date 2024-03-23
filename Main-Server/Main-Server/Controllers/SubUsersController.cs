using Main_Server.Datalayer.Services.Abstract;
using Main_Server.Datalayer.Services.Concrete;
using Main_Server.Infrastructure;
using Main_Server.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace Main_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SubUsersController : ControllerBase
    {
        private readonly SubUserService _subUserService;
        private readonly JwtSettings _jwtSettings;

        public SubUsersController(SubUserService subUserService, IOptions<JwtSettings> jwtSettings)
        {
            _subUserService = subUserService;
            _jwtSettings = jwtSettings.Value;
        }


        [HttpPost]
        public async Task<IActionResult> Add_SubUser(string id, SubUser subUser)
        {
            var result = await _subUserService.Add_SubUser(id, subUser);

            var users = result;

            return Ok(users);
        }

        [HttpGet]
        public async Task<IActionResult> GetById_SubUser(string id, string subId)
        {
            var result = await _subUserService.GetById_SubUser(id,  subId);
            var users = result;
            return Ok(users);
        }

        [HttpDelete]
        public async Task<IActionResult> Delete(string id, string subId)
        {

            var result = await _subUserService.Delete_SubUser(id, subId);
            var users = result;
            return Ok(users);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> List_Subusers(string id)
        {
            var result = await _subUserService.Listed_All_SubUser(id);
            var users = result;
            return Ok(users);
        }


        [HttpPut]

        public async Task<IActionResult> Update_SubUsers(string id,string subId, SubUser subUser)
        {
            var result = await _subUserService.Update_SubUser(id, subId, subUser);
            var users = result;
            return Ok(users);
        }







    }
}
