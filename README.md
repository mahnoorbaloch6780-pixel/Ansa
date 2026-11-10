# Once Upon a Page â€” Fairytale & Fantasy Bookstore âœ¦

An enchanted literary eCommerce web experience featuring fairytale retellings, ethereal fantasy romances, and gilded sprayed-edge collector editions.

## ðŸŒ¿ Overview & Pages
- **`index.html` (Home)**: Hero tableau, "Pick Your Magic" portal tiles, Featured Fairytales carousel, Book of the Month with audio preview, New Arrivals, reader letters, and storybook guarantee.
- **`shop.html` (The Enchanted Library Catalog)**: Full catalog with interactive facet filters (realms/genres, price slider, formats, tropes, star ratings), wishlist hearts, and "Add to Basket" parcel cart.
- **`categories.html` (Storybook Realms & Portals)**: Interactive gateway showcasing 6 realm portals, interactive filters, and an interactive Oracle Quiz to find your destined genre realm.

## ðŸš€ Running on Localhost

To host the bookstore locally at `http://localhost:3000/`, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\server.ps1
```

Or specify a custom port:
```powershell
powershell -ExecutionPolicy Bypass -File .\server.ps1 -Port 8080
```

Then open your browser to:
- **Home**: [http://localhost:3000/](http://localhost:3000/)
- **Shop**: [http://localhost:3000/shop.html](http://localhost:3000/shop.html)
- **Categories**: [http://localhost:3000/categories.html](http://localhost:3000/categories.html)

## âœ¨ Tech Stack
- Pure HTML5 & Vanilla JavaScript
- Modern Tailwind CSS (CDN configured with the custom Enchanted Atelier design palette)
- Google Fonts: Playfair Display & Plus Jakarta Sans
- Google Material Symbols Outlined
- Native PowerShell .NET `HttpListener` local development server (zero dependencies required)
