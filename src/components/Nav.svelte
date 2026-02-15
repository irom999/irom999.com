<script lang="ts">
	import { resolve } from '$app/paths';
	import { page } from '$app/state';
	import * as DarkMode from 'svelte-fancy-darkmode';
	import MoonToSunny from '~icons/line-md/moon-filled-to-sunny-filled-loop-transition';
	import SunnyToMoon from '~icons/line-md/sunny-filled-loop-to-moon-filled-transition';
</script>

{#snippet underline(isPath: boolean, transparentDefault = false)}
	<span
		class={{
			'bg-accent-100': isPath,
			'bg-transparent': !isPath || transparentDefault,
		}}
		absolute
		h-0.5
		w-full
	></span>
{/snippet}

<header
	fcol
	fyc
	gap-y-lg
	grid
	grid-cols="1 md:3"
	mxa
	op="card hover:100"
	py-6
	text-xl
	transition-base
	view-transition--nav
>
	<div flex>
		<a aria-label="Home" font-bold href={resolve('/')} m="xa md:(b0 x0)" relative>
			<div style:view-transition-name="title-irom999" class={{ hidden: page.url.pathname === '/' }}>
				@irom999
			</div>
			<div>{@render underline(page.url.pathname === '/', true)}</div>
		</a>
	</div>
	<nav col-span-2 flex="wrap" font-bold fyc gap-4 m="xa md:r0" md-fxe text-lg>
		<div flex gap="4 md:2" view-transition--nav-icons>
			<DarkMode.ToggleButton>
				{#snippet dark()}
					<SunnyToMoon />
				{/snippet}

				{#snippet light()}
					<MoonToSunny />
				{/snippet}
			</DarkMode.ToggleButton>
		</div>
	</nav>
</header>

<style>
	a {
		--uno: no-underline;
	}
</style>
