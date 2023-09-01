import instaloader

# Crie uma instância do Instaloader
loader = instaloader.Instaloader(
  download_pictures=True,
  download_videos=True,
  download_video_thumbnails=False,
  download_geotags=False,
  download_comments=False,
  save_metadata=False,
  compress_json=False,
  filename_pattern='{profile}_{mediaid}'
  )

# Carregue um perfil público
perfilFafire = instaloader.Profile.from_username(loader.context, 'unifafire')

# Itere pelas postagens e faça o download
for post in perfilFafire.get_posts():
    print("Baixando post:", post.url)
    loader.download_post(post, target=perfilFafire.username)