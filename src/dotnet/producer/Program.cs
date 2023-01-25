using TechTalksModel;
using Dapr.Client;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddControllers().AddDapr();

var app = builder.Build();
app.UseCloudEvents();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// dummy method for testing the minimal API
app.MapGet("/test", (string name) =>
{
    Console.WriteLine($"Hello {name}!");
}).WithOpenApi();

app.MapGet("/generate", (int numberOfTalks) =>
{
    Console.WriteLine($"Generating {numberOfTalks} TechTalks");

    var dummyTechTalks = new TechTalksGenerator().Generate(numberOfTalks);

    string pubsubName = "rabbitmq-pubsub";
    string topicName = "techtalks";

    Console.WriteLine($"Publishing {numberOfTalks} TechTalks to message queue");

    using (var client = new DaprClientBuilder().Build())
    {
        dummyTechTalks.ForEach(talk =>
        {
            CancellationTokenSource source = new CancellationTokenSource();
            CancellationToken cancellationToken = source.Token;

            client.PublishEventAsync(pubsubName, topicName, talk, cancellationToken);

            Console.WriteLine($"{talk} published to message queue");
        });
    }

    Console.WriteLine($"Published {numberOfTalks} TechTalks to message queue");

})
.WithName("GenerateTechTalks")
.WithOpenApi();

app.UseHttpsRedirection();

app.Run();

