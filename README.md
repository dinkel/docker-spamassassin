docker-spamassassin
===================

SpamAssassin as a Docker image. It runs `spamd` on exposed port `783` and
constantly updates its ruleset.

Usage
-----

    docker run -d -p 783:783 dinkel/spamassassin

or linked (this is how I use it)

    docker run -d --name spamassassin dinkel/spamassassin
    docker run -d --link spamassassin:spamassassin application-with-spamc-or-something

Configuration (environment variables)
-------------------------------------

None at the moment.

Data persistence
----------------

It has been a design decision to discard exporting the ruleset to a data
volume as it will be always be brought up-to-date (quite quickly) upon starting
a new container. Also currently there is no intention to have a custom config.

Explaining run.sh
-----------------

This is a poor man's `supervisord`. It is my strong (but not so much challenged)
belief, that there shouldn't be yet another process manager (Docker has one,
CoreOS has one (with `fleet` and `systemd`).

The only thing this script does is watching its forked (background) processes
and as soon as one dies, it terminates all the others and exits with the code
of the first dying process.

Todo
----

* Make sure my little script above works in all circumstances. I know that when
  omitting the `-d` one cannot stop the process using `<Ctrl><c>`.
