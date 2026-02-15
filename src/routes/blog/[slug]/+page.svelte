<script lang="ts">
	import { dev } from '$app/environment';
	import LargeTitle from '$components/LargeTitle.svelte';
	import './prose.css';

	const { data } = $props();
</script>

<div min-w-0 mxa>
	<hgroup fcol fyc gap-1 mb-3 text-center>
		<LargeTitle
			opacity={false}
			selectDisabled={false}
			title={data.post.title}
			viewTransitionName="blog-{data.post.slug}"
		/>
		<p text-text-400>{data.post.date}</p>
	</hgroup>

	<div p2>
		<hr ma max-w-100 op25 w-full />
	</div>

	<article
		class={['prose dark:prose-invert', !dev && 'slide-enter-content']}
		mxa
		pb-8
		text-text="700 dark:200"
	>
		{@html data.post.html}
	</article>
</div>

<style>
	:global(article a) {
		--uno: no-underline hover: underline;
	}
</style>
