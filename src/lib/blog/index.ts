import fs from 'node:fs';
import path from 'node:path';
import matter from 'gray-matter';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import rehypePrettyCode from 'rehype-pretty-code';
import rehypeSlug from 'rehype-slug';
import rehypeStringify from 'rehype-stringify';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import { unified } from 'unified';

export interface BlogPost {
	slug: string;
	title: string;
	description: string;
	date: string;
	published: boolean;
	tags: string[];
}

export interface BlogPostWithContent extends BlogPost {
	html: string;
}

const BLOG_DIR = path.resolve('src/content/blog');

function readMarkdownFiles(): { slug: string; raw: string }[] {
	if (!fs.existsSync(BLOG_DIR)) return [];

	return fs
		.readdirSync(BLOG_DIR)
		.filter((f) => f.endsWith('.md'))
		.map((f) => ({
			slug: f.replace('.md', ''),
			raw: fs.readFileSync(path.join(BLOG_DIR, f), 'utf-8'),
		}));
}

export function getPosts(): BlogPost[] {
	return readMarkdownFiles()
		.map(({ slug, raw }) => {
			const { data } = matter(raw);
			if (!data.published) return null;

			return {
				slug,
				title: data.title ?? slug,
				description: data.description ?? '',
				date: data.date ?? '',
				published: data.published ?? false,
				tags: data.tags ?? [],
			} satisfies BlogPost;
		})
		.filter((p): p is BlogPost => p !== null)
		.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
}

export async function getPost(slug: string): Promise<BlogPostWithContent | null> {
	const filePath = path.join(BLOG_DIR, `${slug}.md`);

	if (!fs.existsSync(filePath)) return null;

	const raw = fs.readFileSync(filePath, 'utf-8');
	const { data, content } = matter(raw);

	const result = await unified()
		.use(remarkParse)
		.use(remarkRehype)
		.use(rehypeSlug)
		.use(rehypeAutolinkHeadings, { behavior: 'wrap' })
		.use(rehypePrettyCode, { theme: 'github-dark' })
		.use(rehypeStringify)
		.process(content);

	return {
		slug,
		title: data.title ?? slug,
		description: data.description ?? '',
		date: data.date ?? '',
		published: data.published ?? false,
		tags: data.tags ?? [],
		html: result.toString(),
	};
}
