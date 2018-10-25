# password_manager

Cli to handle encryption of a json file data which contains web site passwords.  
It encrypt the file in AES-256-CBC with the given password then format it in base64.
There are no way to recover the file data if the password is lose so be careful.

### Requirement
- Ruby 2.4
- Bundler 1.16.0

### Installation

As the gem is only present in Github you must clone it in order to install.

```sh
  git clone https://github.com/Rainiugnas/password_manager
  cd password_manager

  bundle install
  bin/install
```

```ruby
gem 'PasswordManager'
```

### Usage

Once the cli installed, you can start to use it.
First build an empty json file (let's say password.json):

```json
  {}
```

Then encrypt it by running: `password_manager -f password.json --encrypt`.

Now that the file is build and encrypted you can use the following command on it.

- `decrypt` to convert the file in json format (you must re encrypt it in order to use the commands)
- `list` to get all the site name present in the file
- `show` to display a specific site the data
- `add` to add a new site in the file (it will ask you the site data)
- `tmp` to decrypt the file and press enter to encrypt it, useful to manually edit the file (if any error is made in the file the encryption will fail).

All this commands require an encrypted file and leave the file encrypted (except for decrypt).

#### Site format

Site fixe attributes:

- `name` must be unique per file
- `username` user name
- `password` can be blank

A site can also have any other attribute that you want.  
Note that a site must have a name and at least an username or an email

Example of valid json file.
```json
  "site.com": {
    "username": "foo",
    "password": "bar"
  },
  "another-site.com": {
    "username": "foo",
    "password": "bar",
    "notes": ["lorem", "ipsum"],
    "email": "toto@tata.titi"
  }
```

Be sure to alway have valid json file and site else it will fail to parse.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
