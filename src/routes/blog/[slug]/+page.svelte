<script lang="ts">
	import { dev } from '$app/environment';
	import LargeTitle from '$components/LargeTitle.svelte';
	import './prose.css';

	const { data } = $props();
</script>

<div class="min-w-0 mxa">
	<hgroup class="fcol fyc gap-1 mb-3 text-center">
		<LargeTitle
			opacity={false}
			selectDisabled={false}
			title={data.post.title}
			viewTransitionName="blog-{data.post.slug}"
		/>
		<p class="text-text-400">{data.post.date}</p>
	</hgroup>

	<div class="p2">
		<hr class="ma max-w-100 op25 w-full" />
	</div>

	<article
		class={['prose dark:prose-invert mxa pb-8 text-text-700 dark:text-text-200', !dev && 'slide-enter-content']}
	>
		{@html data.post.html}
	</article>
</div>

<style>
	:global(article a) {
		--uno: no-underline hover: underline;
	}
</style>
