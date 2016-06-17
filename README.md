# mix jorel

Elixir Mix Task to use [Jorel](https://github.com/emedia-project/jorel).

## Tasks

* `jorel.release` : Release your app.
* `jorel.tar` : Create a Tar archive with your release.
* `jorel.zip` : Create a Zip archive with your release.
* `jorel.deb` : Create a Debian package with your release.
* `jorel.gen_config` : Create a default Jorel configuration.
* `jorel.dockerize` : Create a [docker](https://www.docker.com/) image with your release.

## Installation

Add `jorel_mix` in your dependencies.

```
{jorel_mix:, "~> 0.0.1"}
```

or

```
{:jorel_mix, git: "https://github.com/emedia-project/jorel_mix", branch: "master"},
```

## Configure

Create a `jorel` function in your `mix.exs` file.

This function must return an an array containing the jorel configuration. See [jorel.in](http://jorel.in/configuration/) for more informations.

Example :

```elixir
def jorel do
  [
    ignore_deps: [:jorel_mix],
    all_deps: false,
    output_dir: '_jorel',
    boot: [:jorel_sample, :sasl],
    exclude_dirs: ['**/_jorel/**', '**/_rel*/**', '**/test/**'],
    include_src: true,
    include_erts: true,
    sys_config: 'config/config.exs',
    disable_relup: false,
    providers: [:jorel_provider_tar, :jorel_provider_zip, :jorel_provider_deb, :jorel_provider_config]
  ]
end
```

## Usage

```
mix deps.get
mix compile
mix jorel.release
```

## Contributing

1. Fork it ( https://github.com/emedia-project/jorel_mix/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request

## Licence

Copyright (c) 2016, G-Corp<br />
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
1. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

