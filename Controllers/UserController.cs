using Microsoft.AspNetCore.Mvc;

namespace PilaniDevOpBackendCode.Controllers;

[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase
{
    private static readonly string[] Names = new[]
    {
        "Don", "El", "Mmm", "Nana", "Ooh"
    };

    private readonly ILogger<UserController> _logger;

    public UserController(ILogger<UserController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "GetUserSet")]
    public IEnumerable<User> Get()
    {
        return Names.Select( x => new User {Username = x});
    }
}
