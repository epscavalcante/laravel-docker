<?php

namespace Tests\Unit;

use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    use DatabaseMigrations;

    /**
     * A basic test example.
     */
    public function test_that_true_is_true(): void
    {
        $this->assertTrue(true);
    }

    public function test_that_user_exists_into_database(): void
    {
        $email = 'user@test.com';

        User::factory()->create(['email' => $email]);

        $this->assertDatabaseCount('users', 1);

        $this->assertDatabaseHas('users', [
            'email' => $email,
        ]);
    }

    public function test_that_user_was_deleted(): void
    {
        $email = 'user@test.com';

        $user = User::factory()->create(['email' => $email]);

        $this->assertDatabaseCount('users', 1);

        $this->assertDatabaseHas('users', [
            'email' => $email,
        ]);

        $this->assertNotSoftDeleted('users', [
            'email' => $email,
        ]);

        $user->delete();

        $this->assertSoftDeleted('users', [
            'email' => $email,
        ]);
    }
}
