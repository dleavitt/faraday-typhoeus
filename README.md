# Faraday Adapter Template

This repo is a template for building [Faraday][faraday] adapters.
Faraday is an HTTP client library that provides a common interface over many adapters.
Every adapter is defined into it's own gem. Use this repository to create your own adapter gem.

## Getting Started

### Setting up and cloning the repo

You can start using GitHub's [Use this template][use-template] button.
![Use this template](https://docs.github.com/assets/images/help/repository/use-this-template-button.png)

This will create a repository based off from this template.
After that is created, you can clone it locally to start working on it.

### Refactoring the template

The next step is for you to find and replace all the "parametrised" names in this template and change them to make it unique.
First of all, you should decide on the name of your adapter.
The current convention (which is by no means mandatory) is to call adapter gems as `faraday-<adapter_name>`.
Here are some examples:

* `HTTP`: [`faraday-http`][faraday-http]
* `Net::HTTP`: [`faraday-net_http`][faraday-net_http]

In this template repository, the placeholder for your chosen adapter name is `MyAdapter` (`my_adapter`).
So once you decide on the final name you want to use you should update all occurrences of `MyAdapter` and all files with `my_adapter` in their name with the new name you chose.

### Main implementation

The bulk of the implementation is in the `Faraday::Adapter::MyAdapter` class.
We've added lots of comments in there to guide you through it, but if you have any doubt/question please don't hesitate to get in touch! 

[faraday]: https://github.com/lostisland/faraday
[faraday-http]: https://github.com/lostisland/faraday-http
[faraday-net_http]: https://github.com/lostisland/faraday-net_http
[use-template]: https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
