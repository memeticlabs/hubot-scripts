hubot-scripts
=============

Hubot scripts which makes life easier and fun @Airwoot

### Stuffweread.coffee
Utility tweets out a reading recommendation from hipchat via a common twitter account on behalf of a hipchat user.

Usage:
  * From within hipchat call hubot with the following command

```
@hubot read [URL] [#hashtag]
```

  * On success, you will hear

```
@twitterhandle just tweeted: [user] recommends [URL] [#hashtags]
```

Dependencies:

  * underscore
  * twit