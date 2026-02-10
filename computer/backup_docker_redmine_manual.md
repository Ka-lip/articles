# Backup from the old machine

1. Get the name of the volumes
    `docker volume ls`

1. Confirm the contents in the volumes
    `docker run --rm -v redmine_work_sqlite:/v alpine sh -lc "ls -lah /v; du -sh /v"`
    `docker run --rm -v redmine_work_files:/v alpine sh -lc "ls -lah /v; du -sh /v"`

1. Back the volume as a single file
    ```bash
    docker run --rm \
      -v redmine_work_sqlite:/volume \
      -v $(pwd):/backup \
      alpine tar czf /backup/redmine_work_sqlite_backup.tgz -C /volume .
    ```

    ```bash
    docker run --rm \
      -v redmine_work_files:/volume \
      -v $(pwd):/backup \
      alpine tar czf /backup/redmine_work_files_backup.tgz -C /volume .
    ```

# Restore the data on the new machine

1. Create the volumes
    ```bash
    docker volume create redmine_work_sqlite
    docker volume create redmine_work_files
    ```

1. Extract the files into the volumes
    ```bash
    docker run --rm \
      -v redmine_work_sqlite:/volume \
      -v $(pwd):/backup \
      alpine sh -c "cd /volume && tar xzf /backup/redmine_work_sqlite_backup.tgz"
    ```

    ```bash
    docker run --rm \
      -v redmine_work_files:/volume \
      -v $(pwd):/backup \
      alpine sh -c "cd /volume && tar xzf /backup/redmine_work_files_backup.tgz"
    ```

1. Run the container
    `docker compose up -d`


# Reference
compose.yml
```yml
services:
  work:
    image: redmine:latest
    ports:
      - "3000:3000"
    volumes:
      - work_sqlite:/usr/src/redmine/sqlite
      - work_files:/usr/src/redmine/files
    environment:
      REDMINE_SECRET_KEY_BASE: "your-secret-key"

volumes:
  work_sqlite:
  work_files:
```


# Transit from docker volumes to system directories

1. Make directories SQLite and files
    ```bash
    sudo mkdir -p /srv/redmine/work/sqlite
    sudo mkdir -p /srv/redmine/work/files
    ```

1. Shut down the container
    ```bash
    docker compose down
    ```


1. Extract the volumes
    ```bash
    docker run --rm \
      -v redmine_work_sqlite:/src \
      -v /srv/redmine/work/sqlite:/dst \
      alpine sh -lc 'cd /src && tar cpf - . | tar xpf - -C /dst'

    docker run --rm \
      -v redmine_work_files:/src \
      -v /srv/redmine/work/files:/dst \
      alpine sh -lc 'cd /src && tar cpf - . | tar xpf - -C /dst'

    ```

1. Confirm the contents in the directories
    ```bash
    sudo ls -lah /srv/redmine/work/sqlite
    sudo du -sh /srv/redmine/work/sqlite

    sudo ls -lah /srv/redmine/work/files | head -50
    sudo du -sh /srv/redmine/work/files
    ```

1. Revise the compose.yml
    ```yml
    services:
      work:
        image: redmine:latest
        ports:
          - "3000:3000"
        volumes:
          - /srv/redmine/work/sqlite:/usr/src/redmine/sqlite
          - /srv/redmine/work/files:/usr/src/redmine/files
        environment:
          REDMINE_SECRET_KEY_BASE: "your-secret-key"
    ```

1. Restart the docker container to see whether it works
    ```bash
    docker compose up -d
    ```

1. Delete the volumes that will not be used anymore
    ```bash
    docker volume rm redmine_work_sqlite redmine_work_files
    ```
