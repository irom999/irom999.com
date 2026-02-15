<script lang="ts">
	import { onNavigate } from '$app/navigation';
	import { page } from '$app/state';
	import Nav from '$components/Nav.svelte';
	import { Header as DarkModeHeader } from 'svelte-fancy-darkmode';
	import { MetaTags } from 'svelte-meta-tags';
	import 'uno.css';
	import '@unocss/reset/tailwind.css';

	const { children } = $props();

	onNavigate((navigation) => {
		if (!document?.startViewTransition) {
			return;
		}

		return new Promise((resolve) => {
			document.startViewTransition(async () => {
				resolve();
				await navigation.complete;
			});
		});
	});

	const title = $derived(page.data.title ?? 'home');
	const description = `Portfolio of @irom999`;
</script>

<DarkModeHeader themeColors={{ dark: '#0F0F0F', light: '#ffffff' }} />

<MetaTags
	{description}
	openGraph={{
		url: page.url.href,
		type: 'website',
		title,
		description,
	}}
	{title}
	titleTemplate={title !== 'home' ? `%s | irom999.com` : 'irom999.com'}
	twitter={{
		cardType: 'summary',
		site: '@irom999',
		title,
		description,
	}}
/>

<main max-w-4xl mxa my3 px-8 un-dark>
	<Nav />
	{#key page.url}
		{@render children()}
	{/key}
</main>

<style>
	:global {
		body {
			--uno: font-sans text-base bg-white text-text-800 dark: (bg-bg-base text-text-100)
				motion-safe: (transition transition-duration-1s scroll-smooth);
			text-autospace: normal;
			overflow-wrap: anywhere;
			word-break: normal;
			line-break: strict;
		}
		@view-transition {
			navigation: auto;
		}
	}
</style>
