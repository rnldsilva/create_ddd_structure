@echo off

cls

if "%~1"=="" goto sem_nom_solution

if "%~2"=="" goto sem_versao_dotnet 

if "%~3"==--force goto clear 

:inicio
set solution_name=%1

set sdk_version=%2

if exist %solution_name% goto solution_existente

mkdir %solution_name%

cd %solution_name%

dotnet new globaljson --sdk-version %sdk_version%

dotnet new gitignore

dotnet new sln --name %solution_name%

dotnet new webapi --framework "net6.0" -o %solution_name%.API
dotnet new classlib --framework "net6.0" -o %solution_name%.Application
dotnet new classlib --framework "net6.0" -o %solution_name%.Domain
dotnet new classlib --framework "net6.0" -o %solution_name%.Infrastructure.Data
dotnet new classlib --framework "net6.0" -o %solution_name%.Infrastructure.IoC

cd %solution_name%.API
mkdir Mapping
cd Mapping
goto criar_mapping
:continuar_api
cd..
del WeatherForecast.cs
cd Controllers
del WeatherForecastController.cs
cd..
goto criar_program
:continuar2_api
cd..
cd %solution_name%.Application
del Class1.cs
mkdir Communication
mkdir Interfaces
mkdir Services
cd..


cd %solution_name%.Domain
del Class1.cs
mkdir DTOs
mkdir Entities
mkdir Interfaces
cd Interfaces
goto criar_irepository
:continuar_domain
cd ..
mkdir Validations
cd..


cd %solution_name%.Infrastructure.Data
del Class1.cs
mkdir Context
cd Context
goto criar_context
:continuar_context
cd ..
mkdir Mapping
mkdir Repository
cd Repository
goto criar_repository
:continuar_data
cd..
cd..


cd %solution_name%.Infrastructure.IoC
del Class1.cs
goto criar_dependency_container
:continuar_ioc
cd..


dotnet sln %solution_name%.sln add %solution_name%.API\%solution_name%.API.csproj --solution-folder "1. API"
dotnet sln %solution_name%.sln add %solution_name%.Application\%solution_name%.Application.csproj --solution-folder "2. Application"
dotnet sln %solution_name%.sln add %solution_name%.Domain\%solution_name%.Domain.csproj --solution-folder "3. Domain"
dotnet sln %solution_name%.sln add %solution_name%.Infrastructure.Data\%solution_name%.Infrastructure.Data.csproj --solution-folder "4. Infrastructure"
dotnet sln %solution_name%.sln add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj --solution-folder "4. Infrastructure"

dotnet sln %solution_name%.sln add %solution_name%.API\%solution_name%.API.csproj
dotnet sln %solution_name%.sln add %solution_name%.Application\%solution_name%.Application.csproj
dotnet sln %solution_name%.sln add %solution_name%.Domain\%solution_name%.Domain.csproj
dotnet sln %solution_name%.sln add %solution_name%.Infrastructure.Data\%solution_name%.Infrastructure.Data.csproj
dotnet sln %solution_name%.sln add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj

dotnet add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj reference %solution_name%.Application\%solution_name%.Application.csproj
dotnet add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj reference %solution_name%.Infrastructure.Data\%solution_name%.Infrastructure.Data.csproj

dotnet add %solution_name%.Infrastructure.Data\%solution_name%.Infrastructure.Data.csproj reference %solution_name%.Domain\%solution_name%.Domain.csproj

dotnet add %solution_name%.Application\%solution_name%.Application.csproj reference %solution_name%.Domain\%solution_name%.Domain.csproj

dotnet add %solution_name%.API\%solution_name%.API.csproj reference %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj

rem Instalação de pacotes no projeto Data:
dotnet add %solution_name%.Infrastructure.Data\%solution_name%.Infrastructure.Data.csproj package Oracle.EntityFrameworkCore -v 6.21.61

rem Instalação de pacotes no projeto IoC:
dotnet add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj package AutoMapper -v 11.0.1
dotnet add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj package AutoMapper.Extensions.Microsoft.DependencyInjection -v 11.0.0
dotnet add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj package Microsoft.EntityFrameworkCore -v 6.0.6
dotnet add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj package Microsoft.Extensions.Configuration.Abstractions -v 6.0.0
dotnet add %solution_name%.Infrastructure.IoC\%solution_name%.Infrastructure.IoC.csproj package Microsoft.Extensions.DependencyInjection.Abstractions -v 6.0.0

rem Instalação de pacotes no projeto Domain:
dotnet add %solution_name%.Domain\%solution_name%.Domain.csproj package FluentValidation.AspNetCore -v 11.1.2

rem Instalação de pacotes no projeto Appication:
dotnet add %solution_name%.Application\%solution_name%.Application.csproj package Newtonsoft.Json -v 13.0.1

rem Instalação de pacotes no projeto API:
dotnet add %solution_name%.API\%solution_name%.API.csproj package AutoMapper -v 11.0.1
dotnet add %solution_name%.API\%solution_name%.API.csproj package AutoMapper.Extensions.Microsoft.DependencyInjection -v 11.0.0
dotnet add %solution_name%.API\%solution_name%.API.csproj package Microsoft.AspNetCore.Authentication.JwtBearer -v 6.0.7
dotnet add %solution_name%.API\%solution_name%.API.csproj package Microsoft.AspNetCore.Mvc.NewtonsoftJson -v 6.0.6
dotnet add %solution_name%.API\%solution_name%.API.csproj package Microsoft.Identity.Web -v 1.25.1
dotnet add %solution_name%.API\%solution_name%.API.csproj package Swashbuckle.AspNetCore -v 6.2.3
cd ..

dotnet build %solution_name%\%solution_name%.API\%solution_name%.API.csproj
goto end


:sem_nom_solution
echo Informe o nome da Solution!
exit /b


:sem_versao_dotnet
echo Informe a versao do Dotnet Core!
exit /b


:solution_existente
echo Solution ja existe neste local!
exit /b


:clear
rmdir /s /q %solution_name%
goto inicio


:end
@echo Concluido!
exit /b


:criar_dependency_container
echo using %solution_name%.Infrastructure.Data.Context; > DependencyContainer.cs
echo using Microsoft.EntityFrameworkCore; >> DependencyContainer.cs
echo using Microsoft.Extensions.Configuration; >> DependencyContainer.cs
echo using Microsoft.Extensions.DependencyInjection; >> DependencyContainer.cs
echo
echo namespace %solution_name%.Infrastructure.IoC >> DependencyContainer.cs
echo { >> DependencyContainer.cs
echo.    public class DependencyContainer >> DependencyContainer.cs
echo.    { >> DependencyContainer.cs
echo.        public static void RegisterServices(IServiceCollection services, IConfiguration configuration) >> DependencyContainer.cs
echo.        { >> DependencyContainer.cs
echo.            services.AddDbContext^<%solution_name%Context^>(options =^> >> DependencyContainer.cs
echo.            { >> DependencyContainer.cs
echo.                options.UseOracle(configuration.GetConnectionString("ConnectionStringName"), b =^> b.MigrationsAssembly(typeof(%solution_name%Context).Assembly.FullName)); >> DependencyContainer.cs
echo.            }); >> DependencyContainer.cs
echo.            services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies()); >> DependencyContainer.cs
echo
echo.            //Add services configuration here... >> DependencyContainer.cs
echo
echo.        } >> DependencyContainer.cs
echo.    } >> DependencyContainer.cs
echo } >> DependencyContainer.cs
goto continuar_ioc


:criar_context
echo using Microsoft.EntityFrameworkCore; > %solution_name%Context.cs
echo namespace %solution_name%.Infrastructure.Data.Context >> %solution_name%Context.cs
echo { >> %solution_name%Context.cs
echo.    public class %solution_name%Context : DbContext >> %solution_name%Context.cs
echo.    { >> %solution_name%Context.cs
echo.        public %solution_name%Context(DbContextOptions options) : base(options) {} >> %solution_name%Context.cs
echo.        protected override void OnModelCreating(ModelBuilder modelBuilder) >> %solution_name%Context.cs
echo.        { >> %solution_name%Context.cs
echo.            base.OnModelCreating(modelBuilder); >> %solution_name%Context.cs
echo.        } >> %solution_name%Context.cs
echo.    } >> %solution_name%Context.cs
echo } >> %solution_name%Context.cs
goto continuar_context


:criar_irepository
echo using System.Linq.Expressions; > IRepository.cs
echo namespace %solution_name%.Domain.Interfaces >> IRepository.cs
echo { >> IRepository.cs
echo.    public interface IRepository^<TEntity^> where TEntity : class >> IRepository.cs
echo.    { >> IRepository.cs
echo.        public IEnumerable^<TEntity^> GetAll(); >> IRepository.cs
echo.        public TEntity GetById(int id); >> IRepository.cs
echo.        public TEntity Find(Expression^<Func^<TEntity, bool^>^> predicate); >> IRepository.cs
echo.        public void Add(TEntity entity); >> IRepository.cs
echo.        public void Update(TEntity entity); >> IRepository.cs
echo.        public void Remove(TEntity entity); >> IRepository.cs
echo.    } >> IRepository.cs
echo } >> IRepository.cs
goto continuar_domain


:criar_repository
echo using Microsoft.EntityFrameworkCore; > Repository.cs
echo using System.Linq.Expressions; >> Repository.cs
echo using %solution_name%.Domain.Interfaces; >> Repository.cs
echo using %solution_name%.Infrastructure.Data.Context; >> Repository.cs
echo namespace %solution_name%.Infrastructure.Data.Repository >> Repository.cs
echo { >> Repository.cs
echo.   public class Repository^<TEntity^> : IRepository^<TEntity^> where TEntity : class >> Repository.cs
echo.   { >> Repository.cs
echo.        private readonly %solution_name%Context context; >> Repository.cs
echo.        public Repository(%solution_name%Context context) >> Repository.cs
echo.        { >> Repository.cs
echo.            this.context = context; >> Repository.cs
echo.        } >> Repository.cs
echo.        public void Add(TEntity entity) >> Repository.cs
echo.        { >> Repository.cs
echo.            this.context.Set^<TEntity^>().Add(entity); >> Repository.cs
echo.            this.context.SaveChanges(); >> Repository.cs
echo.        } >> Repository.cs
echo.        public TEntity Find(Expression^<Func^<TEntity, bool^>^> predicate) >> Repository.cs
echo.        { >> Repository.cs
echo.            return this.context.Set^<TEntity^>().FirstOrDefault(predicate); >> Repository.cs
echo.        } >> Repository.cs
echo.        public IEnumerable^<TEntity^> GetAll() >> Repository.cs
echo.        { >> Repository.cs
echo.            return this.context.Set^<TEntity^>().AsNoTracking().ToList(); >> Repository.cs
echo.        } >> Repository.cs
echo.        public TEntity GetById(int id) >> Repository.cs
echo.        { >> Repository.cs
echo.            return this.context.Set^<TEntity^>().Find(id); >> Repository.cs
echo.        } >> Repository.cs
echo.        public void Remove(TEntity entity) >> Repository.cs
echo.        { >> Repository.cs
echo.            this.context.Remove(entity); >> Repository.cs
echo.            this.context.SaveChanges(); >> Repository.cs
echo.        } >> Repository.cs
echo.        public void Update(TEntity entity) >> Repository.cs
echo.        { >> Repository.cs
echo.            this.context.Set^<TEntity^>().Update(entity); >> Repository.cs
echo.            this.context.SaveChanges(); >> Repository.cs
echo.        } >> Repository.cs
echo.   } >> Repository.cs
echo } >> Repository.cs
goto continuar_data


:criar_mapping
echo using AutoMapper; > DTOToModelProfile.cs
echo namespace %solution_name%.API.Mapping >> DTOToModelProfile.cs
echo { >> DTOToModelProfile.cs
echo.    public class DTOToModelProfile : Profile >> DTOToModelProfile.cs
echo.    { >> DTOToModelProfile.cs
echo.        public DTOToModelProfile() >> DTOToModelProfile.cs
echo.        { >> DTOToModelProfile.cs
echo.            //CreateMap^<DTO, Model^>(); >> DTOToModelProfile.cs
echo.        } >> DTOToModelProfile.cs
echo.    } >> DTOToModelProfile.cs
echo } >> DTOToModelProfile.cs
echo using AutoMapper; > ModelToDTOProfile.cs
echo namespace %solution_name%.API.Mapping >> ModelToDTOProfile.cs
echo { >> ModelToDTOProfile.cs
echo.    public class ModelToDTOProfile : Profile >> ModelToDTOProfile.cs
echo.    { >> ModelToDTOProfile.cs
echo.        public ModelToDTOProfile() >> ModelToDTOProfile.cs
echo.        { >> ModelToDTOProfile.cs
echo.            //CreateMap^<Model, DTO^>(); >> ModelToDTOProfile.cs
echo.        } >> ModelToDTOProfile.cs
echo.    } >> ModelToDTOProfile.cs
echo } >> ModelToDTOProfile.cs
goto continuar_api


:criar_program
echo using Microsoft.AspNetCore.Authentication.JwtBearer; > Program.cs
echo using Microsoft.IdentityModel.Tokens; >> Program.cs
echo using Microsoft.OpenApi.Models; >> Program.cs
echo using System.Reflection; >> Program.cs
echo using System.Text; >> Program.cs
echo using %solution_name%.Infrastructure.IoC; >> Program.cs
echo
echo var builder = WebApplication.CreateBuilder(args); >> Program.cs
echo
echo builder.Services.AddControllers().AddNewtonsoftJson(x =^> x.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore); >> Program.cs
echo
echo builder.Services.AddCors(); >> Program.cs
echo
echo var key = Encoding.ASCII.GetBytes(builder.Configuration.GetSection("SecurityKey").Value); >> Program.cs
echo
echo builder.Services.AddAuthentication(x =^> >> Program.cs
echo { >> Program.cs
echo.    x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme; >> Program.cs
echo.    x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme; >> Program.cs
echo }).AddJwtBearer(x =^> >> Program.cs
echo { >> Program.cs
echo.    x.RequireHttpsMetadata = false; >> Program.cs
echo.    x.SaveToken = true; >> Program.cs
echo.    x.TokenValidationParameters = new TokenValidationParameters >> Program.cs
echo.    { >> Program.cs
echo.        ValidateIssuerSigningKey = true, >> Program.cs
echo.        IssuerSigningKey = new SymmetricSecurityKey(key), >> Program.cs
echo.        ValidateIssuer = false, >> Program.cs
echo.        ValidateAudience = false >> Program.cs
echo.    }; >> Program.cs
echo }); >> Program.cs
echo builder.Services.AddEndpointsApiExplorer(); >> Program.cs
echo builder.Services.AddSwaggerGen(c =^> >> Program.cs
echo { >> Program.cs
echo.    c.SwaggerDoc("v1", new OpenApiInfo { Title = "API %solution_name%", Version = "v1" }); >> Program.cs
echo.    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme >> Program.cs
echo.    { >> Program.cs
echo.        In = ParameterLocation.Header, >> Program.cs
echo.        Description = "Please enter a valid token", >> Program.cs
echo.        Name = "Authorization", >> Program.cs
echo.        Type = SecuritySchemeType.Http, >> Program.cs
echo.        BearerFormat = "JWT", >> Program.cs
echo.        Scheme = "Bearer" >> Program.cs
echo.    }); >> Program.cs
echo.    c.AddSecurityRequirement(new OpenApiSecurityRequirement >> Program.cs
echo.    { >> Program.cs
echo.        { >> Program.cs
echo.            new OpenApiSecurityScheme { >> Program.cs
echo.                Reference = new OpenApiReference >> Program.cs
echo.                { >> Program.cs
echo.                    Type = ReferenceType.SecurityScheme, >> Program.cs
echo.                    Id = "Bearer" >> Program.cs
echo.                } >> Program.cs
echo.            }, >> Program.cs
echo.            new string[]{} >> Program.cs
echo.        } >> Program.cs
echo.    }); >> Program.cs
echo.    var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml"; >> Program.cs
echo.    var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile); >> Program.cs
echo.    c.IncludeXmlComments(xmlPath, includeControllerXmlComments: true); >> Program.cs
echo }); >> Program.cs
echo DependencyContainer.RegisterServices(builder.Services, builder.Configuration); >> Program.cs
echo var app = builder.Build(); >> Program.cs
echo if (app.Environment.IsDevelopment()) >> Program.cs
echo { >> Program.cs
echo.    app.UseSwagger(); >> Program.cs
echo.    app.UseSwaggerUI(c =^> { >> Program.cs
echo.        c.SwaggerEndpoint("/swagger/v1/swagger.json", "v1"); >> Program.cs
echo.    }); >> Program.cs
echo } >> Program.cs
echo app.UseCors(x =^> x.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()); >> Program.cs
echo app.UseAuthentication(); >> Program.cs
echo app.UseAuthorization(); >> Program.cs
echo app.MapControllers(); >> Program.cs
echo app.Run(); >> Program.cs
goto criar_appsettings


:criar_appsettings
echo { > appsettings.json
echo.  "Logging": { >> appsettings.json
echo.    "LogLevel": { >> appsettings.json
echo.      "Default": "Information", >> appsettings.json
echo.      "Microsoft.AspNetCore": "Warning" >> appsettings.json
echo.    } >> appsettings.json
echo.  }, >> appsettings.json
echo.  "AllowedHosts": "*", >> appsettings.json
echo.  "SecurityKey": "Security Key Value", >> appsettings.json
echo.  "ConnectionStrings": { >> appsettings.json
echo.    "ConnectionStringName": "Connection String Value" >> appsettings.json
echo.  } >> appsettings.json
echo } >> appsettings.json
goto continuar2_api


:terceiro_param_invalido
echo Terceiro parametro invalido!
exit /b