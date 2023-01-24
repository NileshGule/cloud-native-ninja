using Bogus;
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

app.UseHttpsRedirection();

app.MapGet("/generate", (int numberOfTalks) =>
{
    var fakeDataCreator = new Faker();

    var categoryNames = new List<string>()
            {
                "Meetup",
                "Free Conference",
                "Paid Conference",
                "Hackathon",
                "EventTribe"
            };

    var categoryDescriptions = new List<string>()
            {
                "Community event organized via meetup",
                "Free Tech Conference",
                "Paid Tech Conference",
                "Hackathon",
                "Community event organized via Eventribe"
            };

    var levelNames = new List<string>()
            {
                "100 - Beginner",
                "200 - Intermediate",
                "300 - Advanced",
                "400 - Expert"
            };

    var techTalks = new Faker<TechTalk>()
    .StrictMode(true)
    .RuleFor(t => t.Id, f => f.Random.Number(1, 1000))
    .RuleFor(t => t.TechTalkName, f => f.Lorem.Word())
    .RuleFor(t => t.CategoryId, f => f.Random.Number(1, 5))
    .RuleFor(t => t.Category, new Category
    {
        Id = fakeDataCreator.Random.Number(1, 5),
        CategoryName = fakeDataCreator.PickRandom(categoryNames),
        Description = fakeDataCreator.PickRandom(categoryDescriptions)
    })
    .RuleFor(t => t.LevelId, f => f.Random.Number(1, 4))
    .RuleFor(t => t.Level, new Level
    {
        Id = fakeDataCreator.Random.Number(1, 4),
        LevelName = fakeDataCreator.PickRandom(levelNames)
    });

    // generate required number of dummy TechTalks
    var dummyTechTalks = techTalks.Generate(numberOfTalks);

    string pubsubName = "rabbitmq-pubsub";
    string topicName = "techtalks";

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

})
.WithName("GenerateTechTalks")
.WithOpenApi();

app.Run("http://localhost:5001");

