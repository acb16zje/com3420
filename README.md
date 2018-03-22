# COM3420 Team 29
###### ZerJun Eng, Alex Chapman, WeiKin Khaw, Ritwesh Chatterjee

---

### Client E: Asset Management System
![D O N O T W A N T](https://media1.tenor.com/images/a136bc5f7e7c57ba0297fe3ce8aefeca/tenor.gif?itemid=10533630)

## Requirements
* Ruby 2.3.1
* Rails 5.1.4
* Linux (recommended)

## Installation
Clone the repository

`git clone git@git.shefcompsci.org.uk:com3420-2017-18/team29/project.git`

Change your directory to the repository

`cd project`

Run the following command to install the required gem

`bundle install`

Create a `database.yml` file inside the `config` folder, and copy the following code into your `database.yml`, replacing the `username, password and database` field with our own given configurations in https://info.shefcompsci.org.uk/hut/database/

```
development: &defaults
  adapter: postgresql
  min_messages: warning
  host: epi-stu-hut-dev-dbs2.shef.ac.uk
  username: YOUR USERNAME
  password: YOUR PASSWORD
  database: YOUR DEVELOPMENT DATABASE

test:
  <<: *defaults
  database: YOUR TEST DATABASE
```


### Significant Features/Technology
The system has the following:

* Search asset
* Book asset
* Booking history
* Favourite category

### Special Development Pre-requisites
None.

### Deployment
*QA -> Demo -> Production* using the `epi-deploy` gem.

[Demo Server](https://team29.demo4.hut.shefcompsci.org.uk/)

### Customer Contact
Some Customer <some.customer@epigenesys.co.uk>
