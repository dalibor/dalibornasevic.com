---
id: 45
title: "My VPS Experience (Linode vs DigitalOcean)"
date: 2014-06-01 09:36:00 +0200
author: Dalibor Nasevic
tags: [linode, digitalocean, vps]
summary: "Why I switched from Linode to DigitalOcean."
---

I've been using [Linode](https://www.linode.com "Linode") for about 4.5 years and I migrated to [Digital Ocean](https://www.digitalocean.com/?refcode=1b34a8d1d224 "Digital Ocean"). So, just want to share some of my personal experience and thoughts here.

I have a small VPS with few websites for my projects that I maintain. I started with a VPS of 512MB at Linode 4.5 years ago for a price of $20 per month. My Linode experience has been great: good stability, great support and nice control panel.

The only thing I can complain about Linode is that I wasn't notified at any time they change their pricing. I ended up paying more and getting less than their updated pricing plans which I don't think is good customer experience. I wonder why I wasn't receiving those upgrade notifications, while a friend that is on other plan do received them. I believe that behavior was selective. 

Initially I was paying $20 for a 512MB VPS at Linode. Then, they changed the pricing to $20 for 1GB and now $20 for 2GB. They keep the same price for smallest plan and just up the RAM memory, CPU and storage.

I think they are making a pricing mistake with that strategy. Digital Ocean, on the other side has packages starting with 512MB, 1GB and up, at a concurrent pricing to Linode. That makes them win the pricing game with Linode and I believe many customers that do need smaller packages already have or will migrate to Digital Ocean unless Linode adds smaller plans.

And finally, my Digital Ocean experience has been good so far. The card approval process was a bit painful because they wanted to verify my identity and the sites I'll be hosting before approving my account. But, their support is great and everything works. I don't need more than a button to create a box, get SSH access, restart box and setup DNS. Add Gmail MX records was a nice catch in their DNS panel.

The most important thing is that **Digital Ocean's pricing is just amazing!** 1GB VPS for $10 is a win. 512MB VPS for $5 is also available which is great.

Let me know your VPS experience and what do you recommend?

**Update 1**: Few days ago I saw  [this post](https://news.ycombinator.com/item?id=6447152 "Stop Using Digital Ocean Now") advising not to use Digital Ocean. And [the response](https://news.ycombinator.com/item?id=6447594 "Stop Using Digital Ocean Now") from Digital Ocean CEO and co-founder.

**Update 2**: Linode added new plan: 1 GB for $10 which makes them more concurrent to Digital Ocean.

**Update 3**: I forgot to mention the other reason I migrated off Linode. I was on an old plan that didn't have SSD and at the time they had auto-migration to new boxes with SSD only for 64 bit OS. And, because I was on a 32 bit system, they told me I'll need to wait 2-3 months for them to implement the auto migration script. So, I felt that's not great customer experience, new accounts to always get benefits and old accounts never get a discount.

**Update 4 (2017-02-16)**: Linode added a $5 plan for a 1GB VPS and they are now more competitive vs Digital Ocean's 512MB for the same price.
