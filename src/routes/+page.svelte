<script>
	import Profile from '$components/Profile.svelte';
	import Social from '$components/Social.svelte';
</script>

<article container gcc mt8 mxa>
	<div animate="duration-1000 keyframes-flip-in-x">
		<Profile />
	</div>
	<div mt8 max-w-2xl mxa px-4>
		<p font="mono bold" text="2xl center gray-600" leading-tight class="word-animation">
			<span class="word">Hi!</span>
			<span class="word">I'm</span>
			<span class="word" style:view-transition-name="title-irom999">irom999.</span>
			<br />
			<span class="word">Click</span>
			<a href="/blog" class="word">here</a>
			<span class="word">to</span>
			<span class="word">check</span>
			<span class="word">my</span>
			<span class="word">blogs.</span>
		</p>
	</div>

	<!-- GitHub Link -->
	<div mt-6 fxc gap-2 px-4 class="github-link">
		<a
			class="btn-blue"
			fyc
			gap-1
			href="https://github.com/irom999"
			target="_blank"
			rel="noopener noreferrer"
		>
			<span class="i-ph-github-logo-duotone"></span>
			GitHub
		</a>
	</div>
</article>

<style>
	.word {
		display: inline-block;
		overflow: hidden;
		max-width: 0;
		animation: typing 0.3s steps(10) forwards;
		margin-right: 0;
		white-space: nowrap;
		opacity: 0;
	}

	a.word {
		color: #fb923c;
		text-decoration: underline;
		cursor: pointer;
		animation:
			typing 0.3s steps(10) forwards,
			color-change 3s ease-in-out infinite 1.4s;
	}

	a.word:hover {
		animation-play-state: paused;
	}

	.word-animation .word:nth-child(1) {
		animation-delay: 0.2s;
	}
	.word-animation .word:nth-child(2) {
		animation-delay: 0.5s;
	}
	.word-animation .word:nth-child(3) {
		animation-delay: 0.8s;
	}
	.word-animation .word:nth-child(4) {
		animation-delay: 1.1s;
	}
	.word-animation .word:nth-child(5) {
		animation-delay: 1.4s;
	}
	.word-animation .word:nth-child(6) {
		animation-delay: 1.7s;
	}
	.word-animation .word:nth-child(7) {
		animation-delay: 2s;
	}
	.word-animation .word:nth-child(8) {
		animation-delay: 2.5s;
	}
	.word-animation .word:nth-child(9) {
		animation-delay: 2.8s;
	}
	.word-animation .word:nth-child(10) {
		animation-delay: 3.1s;
	}
	.word-animation .word:nth-child(11) {
		animation-delay: 3.4s;
	}
	.word-animation .word:nth-child(12) {
		animation-delay: 3.9s;
	}
	.word-animation .word:nth-child(13) {
		animation-delay: 4.2s;
	}
	.word-animation .word:nth-child(14) {
		animation-delay: 4.5s;
	}
	.word-animation .word:nth-child(15) {
		animation-delay: 4.8s;
	}
	.word-animation .word:nth-child(16) {
		animation-delay: 5.1s;
	}
	.word-animation .word:nth-child(17) {
		animation-delay: 5.4s;
	}
	.word-animation .word:nth-child(18) {
		animation-delay: 5.7s;
	}
	.word-animation .word:nth-child(19) {
		animation-delay: 6s;
	}

	@keyframes typing {
		from {
			max-width: 0;
			opacity: 1;
		}
		to {
			max-width: 100%;
			opacity: 1;
		}
	}

	@keyframes color-change {
		0%,
		100% {
			color: #fb923c;
		}
		33% {
			color: #f97316;
		}
		66% {
			color: #c2410c;
		}
	}

	.github-link {
		opacity: 0;
		animation: fade-in-github 0.5s ease-in-out forwards;
		animation-delay: 4s;
	}

	@keyframes fade-in-github {
		from {
			opacity: 0;
		}
		to {
			opacity: 1;
		}
	}
</style>
