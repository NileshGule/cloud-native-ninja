using TechTalksModel;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddControllers().AddDapr();

var app = builder.Build();

app.UseCloudEvents();

app.MapSubscribeHandler();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapPost("/process", ([FromBody] TechTalk techTalk) =>
{
    // Sleep for 250 milliseconds (1/4 of a second) to simulate processing
    Thread.Sleep(TimeSpan.FromMilliseconds(250));

    Console.WriteLine();
    Console.WriteLine("----------");
    Console.WriteLine($"Tech Talk Id : {techTalk.Id}");
    Console.WriteLine($"Tech Talk Name : {techTalk.TechTalkName}");
    Console.WriteLine($"Category : {techTalk.CategoryId}");
    Console.WriteLine($"Level : {techTalk.LevelId}");
    Console.WriteLine("----------");
    Console.WriteLine();

    Console.WriteLine($"TechTalk persisted successfully at {DateTime.Now.ToLongTimeString()}");

    return Results.Ok();
}).WithTopic("rabbitmq-pubsub", "techtalks")
.WithOpenApi();

app.UseHttpsRedirection();

app.Run("http://localhost:6001");

