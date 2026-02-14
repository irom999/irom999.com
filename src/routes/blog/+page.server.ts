import { getPosts } from '$lib/blog';

export function load() {
	const posts = getPosts();
	return { posts, title: 'blog' };
}
