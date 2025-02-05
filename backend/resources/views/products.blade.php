<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            margin: 20px auto;
        }

        .product {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .product img {
            max-width: 150px;
            border-radius: 5px;
        }

        .details {
            flex: 1;
        }

        .details h3 {
            margin: 0;
            font-size: 1.5rem;
        }

        .details p {
            margin: 5px 0;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>Products</h1>
        @foreach ($items as $item)
            <div class="product">
                <img src="{{ $item->image_url }}" alt="{{ $item->name }}"
                    onerror="this.src='https://via.placeholder.com/150'">
                <div class="details">
                    <h3>{{ $item->name }}</h3>
                    <p><strong>Category:</strong> {{ $item->category->name }}</p>
                    <p><strong>Store:</strong> {{ $item->store->name }}</p>
                    <p><strong>Price:</strong> ${{ number_format($item->price, 2) }}</p>
                    <p><strong>Rating:</strong> {{ $item->rating }} / 5</p>
                    <p>{{ $item->description }}</p>
                </div>
            </div>
        @endforeach
    </div>
</body>

</html>
