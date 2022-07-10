<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>Its a home page</h1>
    <div class="aside">
        <h4>Боковая панель</h4>
    </div>

    <a href="/contacts">Contact</a>
    <a href="/about">About</a>


    if($errors->any())
    <p>Errors</p>
    elseif
    <form action="/contacts/submit" method="post">
        @csrf
        <label for="name">Введите имя</label>
        <input type="text", name="name", placeholder="Введите имя". id="name">
        <br>
        <br>
        
        <label for="email">Введите email</label>
        <input type="text", name="email", placeholder="Введите email". id="email">
        <br>
        <br>
        <label for="message">Тема сообщение</label>
        <input type="text", name="message", placeholder="Тема сообщение". id="message">
        <br>
        <label for="subject">Коммент</label>
        <input type="text", name="subject", placeholder="Коммент". id="subject">
        <br>
        <button type="submit">Click</button>
    </form>
</body>
</html>