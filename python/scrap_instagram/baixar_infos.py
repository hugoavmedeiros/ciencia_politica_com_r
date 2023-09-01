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

# Imprime informações do perfil
print("Nome do perfil:", perfilFafire.username)
print("Seguidores:", perfilFafire.followers)
print("Seguindo:", perfilFafire.followees)
print("Número de posts:", perfilFafire.mediacount)

# Imprime a biografia do perfil
print("Biografia:", perfilFafire.biography)