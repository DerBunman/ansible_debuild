#!/usr/bin/env sh
test -d debian || {
	echo "ERROR: no debian dir found."
	exit 1
}
prevtag=initial
pkgname="$(basename $PWD)"
echo > debian/changelog
git tag -l "*" | sort -V | while read tag; do
	[ "$prevtag" = "initial" ] && {
		prevtag="$tag"
		continue
	}

	{
		echo "$pkgname (${tag}) unstable; urgency=low\n";
		git log --pretty=format:'  * %s' $prevtag..$tag;
		git log --pretty='format:%n%n -- %aN <%aE>  %aD%n%n' $tag^..$tag
	}  | cat - debian/changelog | sponge debian/changelog
done
