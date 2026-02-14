import { getPost, getPosts } from '$lib/blog';
import { error } from '@sveltejs/kit';

export async function load({ params }) {
	const post = await getPost(params.slug);

	if (!post) {
		error(404, 'Post not found');
	}

	return { post, title: post.title };
}

export function entries() {
	return getPosts().map((post) => ({ slug: post.slug }));
}
